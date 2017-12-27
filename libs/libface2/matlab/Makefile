MEX := mex
MEXFLAGS := $(shell if uname -m | grep -q x86_64 ; then echo -largeArrayDims ; fi)
MEXSUFFIX := $(shell if uname -m | grep -q x86_64 ; then echo mexa64 ; else echo mexglx ; fi)

MEXFLAGS += -lm

EYEDEADIR = ../dependencies/Eyedea/
ARCH    := $(shell uname -m)


INCLUDES = -I$(EYEDEADIR)Eyedea/ -I$(EYEDEADIR)3rd_Party/

STATICLIBS = ../lib/libface-$(ARCH).a \
             $(EYEDEADIR)Eyedea/libs/libeye-$(ARCH).a \
             $(EYEDEADIR)3rd_Party/.libs/libmatutls-$(ARCH).a \
             $(EYEDEADIR)3rd_Party/iniparser3.0b/src/libiniparser.a 


all: lf_integralimg.$(MEXSUFFIX) lf_integralimg_create.$(MEXSUFFIX) lf_integralimg_free.$(MEXSUFFIX) \
     lf_estimaffinetform.$(MEXSUFFIX) \
     lf_affinetform.$(MEXSUFFIX) \
     lf_affinenormrect.$(MEXSUFFIX) lf_cropanddownscale.$(MEXSUFFIX) lf_lbppyrdetector.$(MEXSUFFIX) \
     lf_lbppyrdetector_score.$(MEXSUFFIX) lf_lbppyrdetector_update_score.$(MEXSUFFIX) \
     lf_lbppyrfilter_init.$(MEXSUFFIX) lf_lbppyrfilter_eval.$(MEXSUFFIX) lf_lbppyrfilter_free.$(MEXSUFFIX)

lf_integralimg.$(MEXSUFFIX):	lf_integralimg_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_integralimg_mex.cpp $(STATICLIBS)

lf_integralimg_create.$(MEXSUFFIX):	lf_integralimg_create_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_integralimg_create_mex.cpp $(STATICLIBS)

lf_integralimg_free.$(MEXSUFFIX):	lf_integralimg_free_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_integralimg_free_mex.cpp $(STATICLIBS)

lf_estimaffinetform.$(MEXSUFFIX):	lf_estimaffinetform_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_estimaffinetform_mex.cpp $(STATICLIBS)

lf_affinetform.$(MEXSUFFIX):	lf_affinetform_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_affinetform_mex.cpp $(STATICLIBS)

lf_affinenormrect.$(MEXSUFFIX):	lf_affinenormrect_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_affinenormrect_mex.cpp $(STATICLIBS)

lf_cropanddownscale.$(MEXSUFFIX):	lf_cropanddownscale_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_cropanddownscale_mex.cpp $(STATICLIBS)

lf_lbppyrdetector.$(MEXSUFFIX):	lf_lbppyrdetector_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_lbppyrdetector_mex.cpp $(STATICLIBS)

lf_lbppyrdetector_score.$(MEXSUFFIX):	lf_lbppyrdetector_score_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_lbppyrdetector_score_mex.cpp $(STATICLIBS)

lf_lbppyrdetector_update_score.$(MEXSUFFIX):	lf_lbppyrdetector_update_score_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_lbppyrdetector_update_score_mex.cpp $(STATICLIBS)

lf_lbppyrfilter_init.$(MEXSUFFIX):	lf_lbppyrfilter_init_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_lbppyrfilter_init_mex.cpp $(STATICLIBS)

lf_lbppyrfilter_free.$(MEXSUFFIX):	lf_lbppyrfilter_free_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_lbppyrfilter_free_mex.cpp $(STATICLIBS)

lf_lbppyrfilter_eval.$(MEXSUFFIX):	lf_lbppyrfilter_eval_mex.cpp
		$(MEX) $(MEXFLAGS) -I../ $(INCLUDES) -DMATLAB -O -output $@ lf_lbppyrfilter_eval_mex.cpp $(STATICLIBS)


clean: 
		rm -f *~ *$(MEXSUFFIX)
