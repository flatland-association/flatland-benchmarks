# coding: utf-8

"""
    FAB Client Lib

    Python client lib to access Flatland Association Benchmarks / AI4REALNET Campaign Hub Backend API, generated with openapi-generator

    The version of the OpenAPI document: 0.0.0
    Contact: contact@flatland-association.org
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


from setuptools import setup, find_packages  # noqa: H301

# To install the library, run the following
#
# python setup.py install
#
# prerequisite: setuptools
# http://pypi.python.org/pypi/setuptools
NAME = "fab-clientlib"
VERSION = "1.0.0"
PYTHON_REQUIRES = ">= 3.9"
REQUIRES = [
    "urllib3 >= 2.1.0, < 3.0.0",
    "python-dateutil >= 2.8.2",
    "pydantic >= 2",
    "typing-extensions >= 4.7.1",
]

setup(
    name=NAME,
    version=VERSION,
    description="FAB Client Lib",
    author="Olivier Stuker, Christian Eichenberger, Manuel Schneider",
    author_email="contact@flatland-association.org",
    url="https://pypi.org/project/fab-clientlib/",
    keywords=["OpenAPI", "OpenAPI-Generator", "FAB Client Lib"],
    install_requires=REQUIRES,
    packages=find_packages(exclude=["test", "tests"]),
    include_package_data=True,
    license="MIT",
    long_description_content_type='text/markdown',
    long_description="""\
    Python client lib to access Flatland Association Benchmarks / AI4REALNET Campaign Hub Backend API, generated with openapi-generator
    """,  # noqa: E501
    package_data={"fab_clientlib": ["py.typed"]},
)