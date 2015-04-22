//+------------------------------------------------------------------+
//|                                         de_compose_indicator.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

#include "CEMDecomp.mqh" 

//#property indicator_chart_window
#property indicator_separate_window
#property indicator_maximum 0.01
#property indicator_minimum -0.01

#property indicator_buffers 5
#property indicator_plots 5
#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_LINE
#property indicator_type3 DRAW_LINE
#property indicator_type4 DRAW_LINE
#property indicator_type5 DRAW_LINE


#property indicator_color1  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width1 3
#property indicator_color2  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width2 3
#property indicator_color3  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width3 3
#property indicator_color4  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width4 3
#property indicator_color5  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width5 3

double indicatorDataBuffer[];
double indicatorColorBuffer[];
double indicatorDataBuffer2[];
double indicatorColorBuffer2[];
double indicatorDataBuffer3[];
double indicatorColorBuffer3[];
double indicatorDataBuffer4[];
double indicatorColorBuffer4[];
double indicatorDataBuffer5[];
double indicatorColorBuffer5[];



int minRequiredBarNumber = 100; // ema period is 20





int OnInit() {

   ArraySetAsSeries(indicatorDataBuffer,true);
   ArraySetAsSeries(indicatorDataBuffer2,true);
   ArraySetAsSeries(indicatorDataBuffer3,true);
   ArraySetAsSeries(indicatorDataBuffer4,true);
   ArraySetAsSeries(indicatorDataBuffer5,true);
   //ArraySetAsSeries(indicatorColorBuffer,true);
      
   SetIndexBuffer(0,indicatorDataBuffer,INDICATOR_DATA);
   //SetIndexBuffer(1,indicatorColorBuffer,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(3,indicatorDataBuffer2,INDICATOR_DATA);
   SetIndexBuffer(4,indicatorDataBuffer3,INDICATOR_DATA);  
   SetIndexBuffer(5,indicatorDataBuffer4,INDICATOR_DATA);
   SetIndexBuffer(5,indicatorDataBuffer5,INDICATOR_DATA);
  
  

               
   return(INIT_SUCCEEDED);
}


int OnCalculate(const int rates_total,       // number of available bars in history at the current tick
                const int prev_calculated,   // number of bars, calculated at previous tick
                const datetime &time[],      
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])   {

   if(rates_total < minRequiredBarNumber) {
      return (0);
   }
   
   int n, ret;
   n = minRequiredBarNumber;
   
   double  yy[], imf1[], imf2[], imf3[], imf4[], imf5[];
   
   ArrayResize(indicatorDataBuffer, n); // indicator buffer will always resized by MT5 to the max avaialble bar number
                                        // so the resize has no effect.
   ArrayResize(yy, n);
   ArrayResize(imf1, n);
   ArrayResize(imf2, n);
   ArrayResize(imf3, n);
   ArrayResize(imf4, n);
   ArrayResize(imf5, n);
   
   ArrayCopy(yy, close,0,0,n);
   printf("yy size is: %d", ArraySize(yy));
   CEMDecomp *emd = new CEMDecomp();
   int total = ArraySize(yy);
   for(int i=0;i<total;i++){
      printf("input yy: %G", yy[i]);   
   }
   ret = emd.Decomp(yy);
   
   
   
   if((ret == 0)&&(emd.nIMF > 3) ) {
      emd.GetIMF(imf2, 1);
   }
   emd.GetIMF(imf1, 0);
   emd.GetIMF(imf3, 2);
   emd.GetIMF(imf4, 3);
   emd.GetIMF(imf5, 5);
   Print("ret=",ret,"   nIMF=",emd.nIMF);
   total = ArraySize(imf2);
   printf("total after is: %d", total);
   for(int i=0;i<total;i++){
      printf("imf1: %G", imf1[i]);
         
   }
   ArraySetAsSeries(imf1,true);
   ArraySetAsSeries(imf2,true);
   ArraySetAsSeries(imf3,true);
   ArraySetAsSeries(imf4,true);
   ArraySetAsSeries(imf5,true);
   ArrayCopy(indicatorDataBuffer,imf1,0,0,WHOLE_ARRAY);
   ArrayCopy(indicatorDataBuffer2,imf2,0,0,WHOLE_ARRAY);
   ArrayCopy(indicatorDataBuffer3,imf3,0,0,WHOLE_ARRAY);
   ArrayCopy(indicatorDataBuffer4,imf4,0,0,WHOLE_ARRAY);
   ArrayCopy(indicatorDataBuffer5,imf5,0,0,WHOLE_ARRAY);
   delete emd;
   return(rates_total);
}


void OnTimer() {

   
}

