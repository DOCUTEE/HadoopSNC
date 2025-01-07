#!/bin/bash
echo "127.0.0.1 minhquang-master" >> /etc/hosts
exec "$@"
