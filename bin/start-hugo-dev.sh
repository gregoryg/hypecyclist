#!/usr/bin/env bash
hugo server --buildDrafts --port 8000 --bind $(ip route get 1|awk '{print $(NF-2);exit}') --baseURL http://penguin.linux.test
