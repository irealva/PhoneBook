#!/bin/sh

bin/make_labs prompt-wav/*.wav

festival -b festvox/build_ldom.scm '(build_utts "etc/NAME.data")'

cp etc/NAME.data etc/txt.done.data

bin/make_pm_wave wav/*.wav
bin/make_pm_fix pm/*.pm

bin/simple_powernormalize wav/*.wav

bin/make_mcep wav/*.wav

festival -b festvox/build_ldom.scm '(build_clunits "etc/NAME.data")'


