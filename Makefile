BASEDIR=$(shell pwd)

help:
	@echo
	@echo " clean: remove transitory files"
	@echo " clean-logs: remove logfiles"
	@echo " flake8: run flake8 against codebase"
	@echo " package: create Python wheel"
	@echo " setup: create store, tileindex keys and indexes"
	@echo " start: start MetPX/Sarracenia data feeds"
	@echo " teardown: delete store, tileindex keys and indexes"
	@echo

clean: stop
	geomet-data-registry store teardown
	geomet-data-registry tileindex teardown

clean-logs:
	rm -fr $(XDG_CACHE_HOME)/*

flake8:
	find . -type f -name "*.py" | grep -v geomet_data_registry/event.py | xargs flake8

package:
	python setup.py sdist bdist_wheel --universal

setup:
	geomet-data-registry store setup
	geomet-data-registry tileindex setup
	
	geomet-data-registry store set -k cansips -c $(BASEDIR)/conf/cansips.yml
	geomet-data-registry store set -k geps -c $(BASEDIR)/conf/geps.yml
	geomet-data-registry store set -k model_gem_global -c $(BASEDIR)/conf/model_gem_global.yml
	geomet-data-registry store set -k model_gem_regional -c $(BASEDIR)/conf/model_gem_regional.yml
	geomet-data-registry store set -k model_giops -c $(BASEDIR)/conf/model_giops.yml
	geomet-data-registry store set -k model_hrdps_continental -c $(BASEDIR)/conf/model_hrdps_continental.yml
	geomet-data-registry store set -k reps -c $(BASEDIR)/conf/reps.yml
	
start:	
	sr_subscribe start $(BASEDIR)/conf/sarracenia/cansips.conf
	sr_subscribe start $(BASEDIR)/conf/sarracenia/geps.conf
	sr_subscribe start $(BASEDIR)/conf/sarracenia/model_gem_global.conf
	sr_subscribe start $(BASEDIR)/conf/sarracenia/model_gem_regional.conf
	sr_subscribe start $(BASEDIR)/conf/sarracenia/model_giops.conf
	sr_subscribe start $(BASEDIR)/conf/sarracenia/model_hrdps_continental.conf
	sr_subscribe start $(BASEDIR)/conf/sarracenia/reps.conf

stop:
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/cansips.conf
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/geps.conf
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/model_gem_global.conf
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/model_gem_regional.conf
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/model_giops.conf
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/model_hrdps_continental.conf
	sr_subscribe stop $(BASEDIR)/conf/sarracenia/reps.conf

.PHONY: clean clean-logs flake8 package setup start stop
