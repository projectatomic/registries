import setuptools

setuptools.setup(
    name='registries',
    version="0.1",
    description='registry parser',
    author='Brent Baude',
    author_email='bbaude@redhat.com',
    url='http://github.com:projectatomic/registries',
    packages=['registries'],
    license='GNU GPL',
    entry_points={
        'console_scripts': [
            'registries = registries.registries:registries',
            'registries_migrator = registries.registries_migrator:migrate'
        ]
    }
)

