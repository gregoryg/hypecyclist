#!/usr/bin/env bash
hugo && rsync --dry-run -av --delete  public/ gortsleigh@dynapse.net:hypecyclist.org/
