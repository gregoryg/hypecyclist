#!/usr/bin/env bash
hugo && rsync  -av --delete  public/ gortsleigh@dynapse.net:hypecyclist.org/
