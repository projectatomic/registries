#include <yaml.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <glib.h>
#include <argp.h>
#include <unistd.h>
#include <json-glib/json-glib.h>

GArray *registries;
GHashTable* hash;
GPtrArray* tmp_values;
char * headers [] = { "registries", "insecure_registries", "block_registries" };
gchar *cur_header = "None";


/*
 * Add  a single value to the tmp_array
 */
void add_value_to_tmp_array(char* value){
	g_ptr_array_add(tmp_values, g_strdup(value));
}

/*
 * Destroy the temporary array and recreate blank
 */
void destroy_tmp_array(){
	g_ptr_array_free(tmp_values, TRUE);
	tmp_values = g_ptr_array_new();
}

/*
 * Determine if a string value is a header
 *
 * Returns: bool
 */
bool is_string_header(char* header)
{
	int i;
	for (i=0; i < sizeof(headers)/sizeof(headers[0]); i++ ) {
		if (!strcmp(headers[i], header)){
			return TRUE;
		}
	}
	return FALSE;
}

/*
 * Iterates the tmp_array values and adds them to a new
 * NULL terminated ptr_array
 */
GPtrArray* assemble_array(){
	GPtrArray* store_values = g_ptr_array_new();
	for (guint i = 0; i < tmp_values->len; i++) {
		g_ptr_array_add(store_values, g_ptr_array_index(tmp_values, i));
	}
	// NULL terminate the array
	g_ptr_array_add (store_values, NULL);
	return store_values;
}

/*
 * Iterates (recursively if needed) the YAML "tree" from the parser
 */
void print_yaml_node(yaml_document_t *document_p, yaml_node_t *node, bool header)
{
	char* heading;
	switch(node->type){

	yaml_node_t *next_node_p;
	// Find start sequences
	case YAML_SEQUENCE_NODE:
		for (yaml_node_item_t *i_node = node->data.sequence.items.start; i_node < node->data.sequence.items.top; i_node++) {

			next_node_p = yaml_document_get_node(document_p, *i_node);
			if (next_node_p)
				print_yaml_node(document_p, next_node_p, FALSE);
		}
		// Add the tmp_array to the hash
		g_hash_table_insert(hash, g_strdup(cur_header), assemble_array());
		destroy_tmp_array();
		cur_header = "None";
		break;

	case YAML_SCALAR_NODE:
		heading = (char*) node->data.scalar.value;
		if (header) {
			if (is_string_header((char*) heading)) {
				cur_header = heading;
			}
		}
		else {
			if (g_strcmp0(cur_header, "None") != 0 ){
				add_value_to_tmp_array((char *)heading);
			}
		}
		break;

	case YAML_MAPPING_NODE:
		for (yaml_node_pair_t *i_node_p = node->data.mapping.pairs.start; i_node_p < node->data.mapping.pairs.top; i_node_p++) {
			next_node_p = yaml_document_get_node(document_p, i_node_p->key);
			if (next_node_p) {
				print_yaml_node(document_p, next_node_p, TRUE);
			}
			next_node_p = yaml_document_get_node(document_p, i_node_p->value);
			if (next_node_p) {
				print_yaml_node(document_p, next_node_p, FALSE);
			}
		}
		break;

	case YAML_NO_EVENT:
		break;

	default:
		printf("@@@Unknown type\n");
		break;
	}
}

/*
 * Given a header, returns the proper switch string
 *
 * Returns: gchar*
 */
gchar* get_switch_from_header(char *header) {
	gchar* ret = NULL;
	if (g_strcmp0 ("registries", header) == 0) {
		ret = " --add-registry ";
	}
	else if (g_strcmp0("insecure_registries", header) == 0){
		ret = " --insecure_registries ";
	}
	else if (g_strcmp0("block_registries", header) == 0){
		ret = " --block_registries ";
	}
	return ret;
}

/*
 * Assembles the information in the hash map and returns it in str format
 *
 * Returns: gchar*
 */
gchar* build_string(){
	gchar *output = "";
	// Build hash lookup
	GList *keys;
	keys = g_hash_table_get_keys(hash);
	for (gint i=0; i< g_list_length(keys); i++){
		gchar* key = g_list_nth_data(keys, i);
		gchar* command_switch = get_switch_from_header(key);
		GPtrArray* values = g_hash_table_lookup(hash, key);
		gchar *value = g_strconcat(command_switch, g_strjoinv(command_switch, (gchar **) values->pdata), NULL);
		output = g_strconcat(g_strdup(output), g_strdup(value), NULL);
	}
	//Output the final string
	return output;
}

/*
 * Assembles the information in the hash map and returns it in JSON format
 *
 * Returns: gchar*
 */
gchar* build_json() {

	GList *keys;
	JsonBuilder *builder = json_builder_new ();

	json_builder_begin_object (builder);

	keys = g_hash_table_get_keys(hash);
	for (gint i=0; i< g_list_length(keys); i++){
		gchar* key = g_list_nth_data(keys, i);
		if (g_strcmp0(key, "None") == 0)
			continue;
		json_builder_set_member_name (builder, key);
		json_builder_begin_array (builder);
		GPtrArray* values = g_hash_table_lookup(hash, key);
		for (guint j = 0; j < values->len; j++){
			if (values->pdata[j] != NULL){
				json_builder_add_string_value(builder, (char *) values->pdata[j]);
			}
		}
		json_builder_end_array (builder);
	}

	json_builder_end_object (builder);

	JsonGenerator *gen = json_generator_new ();
	JsonNode * root = json_builder_get_root (builder);
	json_generator_set_root (gen, root);
	gchar *output = json_generator_to_data (gen, NULL);

	g_list_free(keys);
	json_node_free (root);
	g_object_unref (gen);
	g_object_unref (builder);

	return output;
}

/*
 * Ensures we the input file exists and we can read it
 */
void check_file(gchar *file_name){
	if (access(file_name, F_OK) == -1){
		fprintf(stderr, "%s does not exist\n", file_name);
		exit (1);
	}

	if (access(file_name, R_OK) == -1){
		fprintf(stderr, "Unable to read %s\n", file_name);
		exit (1);
	}
}

/*
 * Writes the output information to a given file.  If an output_variable
 * is provided, the output information is quoted and the variable is assigned
 * to it.  Like:
 *
 * output_variable="output"
 */
void write_to_file(gchar *output, gchar *output_file, gchar *output_variable){
	FILE *fp;
	fp = fopen(output_file, "w+");
	if (output_variable){
		output = g_strconcat(output_variable, "=\"", output, "\"", NULL);
	}
	fprintf(fp, "%s\n", output);
	fclose(fp);

}

int main(int argc, char *argv[])
{
	// Global vars
	hash = g_hash_table_new_full(g_str_hash, g_str_equal, NULL, NULL);
	tmp_values = g_ptr_array_new();

	static gboolean json = FALSE;
	static gchar *input_file;
	static gchar *output_file;
	static gchar *output_variable;
	char *conf_file = "/etc/containers/registries.conf";

	static GOptionEntry entries[] =
	{
	  { "input", 'i', 0, G_OPTION_ARG_STRING, &input_file, "Specify an input file", NULL },
	  { "json", 'j', 0, G_OPTION_ARG_NONE, &json, "Output in JSON format", NULL },
	  { "output", 'o', 0, G_OPTION_ARG_STRING, &output_file, "Specify an output file", NULL },
	  { "variable", 'V', 0, G_OPTION_ARG_STRING, &output_variable, "Specify an variable assignment", NULL },
	  { NULL }
	};

	GError *parse_error = NULL;
	GOptionContext *context;

	context = g_option_context_new ("- parses a YAML file to extract registries");
	g_option_context_add_main_entries (context, entries, NULL);
	//g_option_context_add_group (context, gtk_get_option_group (TRUE));
	if (!g_option_context_parse (context, &argc, &argv, &parse_error))
	{
	  g_print ("option parsing failed: %s\n", parse_error->message);
	  exit (1);
	}


	if (input_file){
		conf_file = input_file;
	}

	yaml_parser_t parser;
	yaml_document_t document;
	int error = 0;

	// Check that conf file exists and can be read
	check_file(conf_file);

	FILE *file = fopen(conf_file, "r");
	assert(yaml_parser_initialize(&parser));
	yaml_parser_set_input_file(&parser, file);

	int done = 0;
	while (!done)
	{
		if (!yaml_parser_load(&parser, &document)) {
			fprintf(stderr, "%s is invalid YAML\n", conf_file);
			error = 1;
			break;
		}

		done = (!yaml_document_get_root_node(&document));

		if (!done) {
			print_yaml_node(&document, yaml_document_get_root_node(&document), FALSE);
		}

		yaml_document_delete(&document);
	}

	yaml_parser_delete(&parser);
	assert(!fclose(file));

	if (error == 1)
		return error;

	g_autofree gchar* output;

	if (json){
		output = build_json();
	}

	else {
	 output = build_string();
	}
	if (output_file){
		gchar* output_path = g_path_get_dirname(output_file);
		//Create the directories in the output path
		g_mkdir_with_parents (output_path, 755);
		write_to_file(output, output_file, output_variable);
	}
	else
		printf("%s\n", output);

	 g_option_context_free(context);

}
