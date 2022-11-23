TARGET := iphone:clang:latest:8.0


include ~/theos/makefiles/common.mk

TWEAK_NAME = Retr0Spoof

Retr0Spoof_FILES = Tweak.xm fishhook.c
Retr0Spoof_CFLAGS = -fobjc-arc -mllvm -enable-adb -mllvm -enable-strcry -mllvm -enable-acdobf -mllvm -enable-fco -mllvm -enable-bcfobf -mllvm -sub_loop=2 -mllvm -sub_prob=100 -mllvm -bcf_cond_compl=3   -mllvm -acd-rename-methodimp -mllvm -adb_prob=100 -mllvm -enable-subobf -mllvm -acd-use-initialize -mllvm -enable-indibran -mllvm -enable-splitobf -mllvm -bcf_cond_compl=3 -mllvm -bcf_junkasm_minnum=1
Retr0Spoof_CCFLAGS = -fobjc-arc -mllvm -enable-bcfobf -mllvm -bcf_loop=1 -mllvm -bcf_prob=100 -mllvm -enable-strcry  -mllvm -enable-cffobf -mllvm -enable-cffobf -mllvm -enable-acdobf -mllvm -enable-fco -mllvm -enable-adb -mllvm -bcf_junkasm -mllvm -enable-constenc -mllvm -acd-rename-methodimp -mllvm -adb_prob=100  -mllvm -constenc_times=2 -mllvm -enable-subobf -mllvm -sub_loop=2 -mllvm -sub_prob=100 -mllvm -bcf_cond_compl=3 -mllvm -bcf_junkasm_minnum=1
Retr0Spoof_LOGOS_DEFAULT_GENERATOR = internal

include ~/theos/makefiles/tweak.mk
