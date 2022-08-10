#/bin/sh
conda-repo config --set sites.eca.url https://anacondaprod1.eca.eu/api
conda-repo config --set default_site eca
conda-repo config --set ssl_verify /home/jupyter/eca-chain.txt
conda-repo login
