import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="numrpc",
    version="0.0.1",
    author="Pierre Haessig",
    author_email="pierre.haessig@centralesupelec.fr",
    description="Python implementation of the NumRPC protocol",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/pierre-haessig/numrpc",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)
# TODO: add dependencies : zeromq, ...
