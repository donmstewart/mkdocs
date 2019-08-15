
# MkDocs Project Documentation Container Image

![Docker Automated](https://img.shields.io/docker/cloud/automated/donstewart/mkdocs.svg?style=popout)
![Docker Build](https://img.shields.io/docker/cloud/build/donstewart/mkdocs.svg?style=popout)
![Docker Pulls](https://img.shields.io/docker/pulls/donstewart/mkdocs.svg?style=popout)
![Docker Stars](https://img.shields.io/docker/stars/donstewart/mkdocs.svg?style=popout)
![License](https://img.shields.io/github/license/donmstewart/mkdocs.svg?style=popout)
![GitHub Open Issues](https://img.shields.io/github/issues-raw/donmstewart/mkdocs.svg?style=popout)
![GitHub Closed Issues](https://img.shields.io/github/issues-closed-raw/donmstewart/mkdocs.svg?style=popout)

---

A Docker Container to build MkDocs documentation.

There are a number of option with the Docker Container depending on your goals: -

* Run a local Documentation Server
* Generate the Documentation Site & Exit
* Generate the Documentation Site + Generate a PDF Document & Exit
* Publishing the Documentation to GitHub Pages

## Running the Container - Run a local Documentation Server

In generaye and run a HTTP server exposing the HTML Site, mount the directory containing the `mkdocs.yml` file into the container during the container run: -

``` bash tabs="Bash"
docker run -it -v ${PWD}:/mkdocs -p 8000:8000 donstewart/mkdocs:1.0.4
```

You can browse the documentation at http://localhost:8000/

This site automatically updates as you change the MkDocs Markdown files or `yml` configuration file.

The build output will be in your local filesystem at `./_site`.

!!! warning
    Do not check the `_site_` directory into git make sure it is in your `.gitgnore` file.

## Running the Container - Generate the Documentation & Exit

In order to build the HTML Site mount the directory containing the `mkdocs.yml` file
into the container during the container run: -

``` bash tabs="Bash"
docker run -it -v ${PWD}:/mkdocs donstewart/mkdocs:1.0.4 build
```

When the container exits the build output will be in your local filesystem at `./_site`.

## Running the Container - Generate the Documentation + Generate a PDF Document & Exit

In addition to building the Site HTML it is also possible to generate a PDF document of the markdown site: -

``` bash tabs="Bash"
docker run -it -v ${PWD}:/mkdocs -e ENABLE_PDF_EXPORT=1  donstewart/mkdocs:1.0.4
```

When the container exits the build output will be in your local filesystem at `./_site`.
The PDF file generated can be found at `./_site/PDF/combined.pdf`.

## Running the Container - Publishing the Documentation to GitHub Pages

It is also possible to build & publish the documentation to a GitHub pages site for your project. In order to do this make sure you project is cloned from GitHub and has it's `origin` set correctly. You can then publish using: -

``` bash tabs="Bash"
docker run -it -v ${PWD}:/mkdocs donstewart/mkdocs:1.0.4 gh-deploy
```

> Do not generate the PDF unless you want to store the PDF file in your GitHub repo.

You will find a new branch in your git repository called `gh-pages`.

> Never manually check in the `gh-pages` branch and never ever switch to that branch and make changes.
