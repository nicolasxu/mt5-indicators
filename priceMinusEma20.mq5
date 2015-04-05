//+------------------------------------------------------------------+
//|                                              priceMinusEma20.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
// calculate (price - ema20) and draw result on chart window

#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

#property indicator_separate_window
#property indicator_minimum -0.1
#property indicator_maximum 0.1

#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID

double diffBuffer[];
int minRequiredBarNumber = 20;
int emaHandle;
double emaBuffer[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
    emaHandle =    iMA(  NULL,    // symbol string
                            0,    // timeframe
                           20,    // ma period
                            0,    // ma shift
                     MODE_EMA,    // Smooth method
                  PRICE_CLOSE     // Calculating on Close prices
                 ); 
                 
   ArraySetAsSeries(diffBuffer,true);
   ArraySetAsSeries(emaBuffer,true);
   
   SetIndexBuffer(0,diffBuffer,INDICATOR_DATA);
   
   //--- Set as an empty value 0
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0);   
   
   printf("ema20Handle is: %d", emaHandle);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {


   printf("prev_calculated: %d, rates_total: %d ", prev_calculated, rates_total);

   // don't draw, if no more than 20 bars
   if(rates_total < minRequiredBarNumber){
      return(0);   
   }
   
   // index everything as time series, time[0] is the most recent 
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(time,true);
   
   
   CopyBuffer(emaHandle,0, 0, rates_total - prev_calculated , emaBuffer);
   
   
   for(int i=0;i<rates_total - prev_calculated - 1;i++) {
      
      diffBuffer[i] =   emaBuffer[i] - close[i];
      printf("diffBuffer[%d]: %G", i,diffBuffer[i]);
      //printf(emaBuffer[i]);
   }   
   
   //--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
//---
   
}
//+------------------------------------------------------------------+
