//#############################################################################
// Description:
//
// This example calls the arc-cosine function(CLAacos) of the CLA
// math library on a test vector and compares the result to the
// equivalent "math.h" routine
//
// Copyright (C) 2016 Texas Instruments Incorporated - http://www.ti.com/
// ALL RIGHTS RESERVED
//#############################################################################
//$TI Release: CLA Math Library V4.01.00.00 $
//$Release Date: Apr 6, 2016 $
//#############################################################################
#include <stdint.h>
#include "DSP28x_Project.h"
#include "CLAShared.h"
#include "math.h"

#define EPSILON             1e-1

// Constants
#define WAITSTEP    asm(" RPT #255||NOP")

//Global Variables
extern int16_t pass, fail;

//Task 1 (C) Variables
#ifdef __cplusplus
#pragma DATA_SECTION("CpuToCla1MsgRAM")
float fVal;
#pragma DATA_SECTION("Cla1ToCpuMsgRAM")
float fResult;
#else
#pragma DATA_SECTION(fVal,"CpuToCla1MsgRAM")
float fVal;
#pragma DATA_SECTION(fResult,"Cla1ToCpuMsgRAM")
float fResult;
#endif //__cplusplus

float y[BUFFER_SIZE];
float fError[BUFFER_SIZE];

//Golden Test Values
float test_values[BUFFER_SIZE] ={
  1.0000,   0.9988,   0.9951,   0.9890,   0.9805,   0.9696,   0.9563,   0.9406,
  0.9227,   0.9025,   0.8801,   0.8555,   0.8289,   0.8002,   0.7696,   0.7370,
  0.7027,   0.6667,   0.6290,   0.5898,   0.5491,   0.5071,   0.4639,   0.4195,
  0.3741,   0.3278,   0.2807,   0.2328,   0.1845,   0.1356,   0.0865,   0.0371,
 -0.0124,  -0.0618,  -0.1111,  -0.1601,  -0.2087,  -0.2568,  -0.3043,  -0.3510,
 -0.3969,  -0.4418,  -0.4857,  -0.5283,  -0.5696,  -0.6096,  -0.6480,  -0.6849,
 -0.7201,  -0.7535,  -0.7851,  -0.8148,  -0.8425,  -0.8681,  -0.8916,  -0.9129,
 -0.9319,  -0.9487,  -0.9632,  -0.9753,  -0.9850,  -0.9924,  -0.9972,  -0.9997,
 -0.9997,  -0.9972,  -0.9924,  -0.9850,  -0.9753,  -0.9632,  -0.9487,  -0.9319,
 -0.9129,  -0.8916,  -0.8681,  -0.8425,  -0.8148,  -0.7851,  -0.7535,  -0.7201,
 -0.6849,  -0.6480,  -0.6096,  -0.5696,  -0.5283,  -0.4857,  -0.4418,  -0.3969,
 -0.3510,  -0.3043,  -0.2568,  -0.2087,  -0.1601,  -0.1111,  -0.0618,  -0.0124,
  0.0371,   0.0865,   0.1356,   0.1845,   0.2328,   0.2807,   0.3278,   0.3741,
  0.4195,   0.4639,   0.5071,   0.5491,   0.5898,   0.6290,   0.6667,   0.7027,
  0.7370,   0.7696,   0.8002,   0.8289,   0.8555,   0.8801,   0.9025,   0.9227,
  0.9406,   0.9563,   0.9696,   0.9805,   0.9890,   0.9951,   0.9988,   1.0000
};

float res_expected[BUFFER_SIZE]={
  0.0000,   0.0495,   0.0989,   0.1484,   0.1979,   0.2474,   0.2968,   0.3463,
  0.3958,   0.4453,   0.4947,   0.5442,   0.5937,   0.6432,   0.6926,   0.7421,
  0.7916,   0.8411,   0.8905,   0.9400,   0.9895,   1.0390,   1.0884,   1.1379,
  1.1874,   1.2368,   1.2863,   1.3358,   1.3853,   1.4347,   1.4842,   1.5337,
  1.5832,   1.6326,   1.6821,   1.7316,   1.7811,   1.8305,   1.8800,   1.9295,
  1.9790,   2.0284,   2.0779,   2.1274,   2.1769,   2.2263,   2.2758,   2.3253,
  2.3747,   2.4242,   2.4737,   2.5232,   2.5726,   2.6221,   2.6716,   2.7211,
  2.7705,   2.8200,   2.8695,   2.9190,   2.9684,   3.0179,   3.0674,   3.1169,
  3.1169,   3.0674,   3.0179,   2.9684,   2.9190,   2.8695,   2.8200,   2.7705,
  2.7211,   2.6716,   2.6221,   2.5726,   2.5232,   2.4737,   2.4242,   2.3747,
  2.3253,   2.2758,   2.2263,   2.1769,   2.1274,   2.0779,   2.0284,   1.9790,
  1.9295,   1.8800,   1.8305,   1.7811,   1.7316,   1.6821,   1.6326,   1.5832,
  1.5337,   1.4842,   1.4347,   1.3853,   1.3358,   1.2863,   1.2368,   1.1874,
  1.1379,   1.0884,   1.0390,   0.9895,   0.9400,   0.8905,   0.8411,   0.7916,
  0.7421,   0.6926,   0.6432,   0.5937,   0.5442,   0.4947,   0.4453,   0.3958,
  0.3463,   0.2968,   0.2474,   0.1979,   0.1484,   0.0989,   0.0495,   0.0000
};  



//C28 C tasks
void test_run(void)
{
    int i;
    
    for(i=0;i<BUFFER_SIZE;i++)
    {
     fVal= test_values[i];
     Cla1ForceTask1andWait();
     WAITSTEP;
     y[i] = fResult; 
    }   
}

void test_report(void)
{
    unsigned int i;
    
    float fErrMetric;
    for(i=0;i<BUFFER_SIZE;i++){
      fError[i] = fabs(res_expected[i]-y[i]);
      fErrMetric = fError[i];
      if( fErrMetric < EPSILON){
        pass++;
      }else{
        fail++;
      }
    }
    //if(fail) test_error(); 
}

void test_error( void )
{
    asm(" ESTOP0"); 
}

