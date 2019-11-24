# docker-sphinx

It is a [sphinx][sphinx] environment aimed at generating html and pdf.
In order to make UML diagrams available,
[PlantUML][plantuml] related plugins are added.

[plantuml]: http://plantuml.com/
[sphinx]: http://www.sphinx-doc.org/en/master/

## Usage

By executing as below you can generate html and pdf respectively.

```sh
# Initialize
$ docker run --rm -it -v /source/path:/home/dev/src:rw iimuz/sphinx:latest
$ sphinx-quickstart
$ exit

# Create html
$ docker run --rm -v /source/path:/home/dev/src:rw iimuz/sphinx:latest bash -c "make html"

# Create pdf
$ docker run --rm -v /source/path:/home/dev/src:rw iimuz/sphinx:latest bash -c "make pdf"
```

## PlantUML

In order to use PlantUML, the following package has been added to sphinx.

* sphinxcontrib-actdiag
* sphinxcontrib-blockdiag
* sphinxcontrib-nwdiag
* sphinxcontrib-plantuml
* sphinxcontrib-seqdiag

When using PlantUML, you need to add the following setting to conf.py.

```py
extensions = [
        'sphinxcontrib.actdiag',
        'sphinxcontrib.blockdiag',
        'sphinxcontrib.nwdiag',
        'sphinxcontrib.plantuml',
        'sphinxcontrib.seqdiag',
        ]
plantjar = '/usr/local/plantuml/plantuml.jar'
plantuml = 'java -jar %s' % plantjar
```

