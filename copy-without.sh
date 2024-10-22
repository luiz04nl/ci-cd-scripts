#!/bin/bash

directory_path="src"

find "$directory_path" -type f -name 'Web.*.config' ! -name 'Web.config' -exec rm -f {} \;

echo "Arquivos Web.*.config removed, except Web.config."