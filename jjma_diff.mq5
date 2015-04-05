//+------------------------------------------------------------------+
//|                                                    jjma_diff.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum -0.01
#property indicator_maximum 0.01
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  4


double diffBuffer[];
int minRequiredBarNumber = 7;
int jjmaHandle;
double jjmaBuffer[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   jjmaHandle = iCustom(NULL,0,"Expert_Indicators\\jjma", 7, 100, PRICE_CLOSE,0,0); 
   
   ArraySetAsSeries(diffBuffer,true);
   ArraySetAsSeries(jjmaBuffer,true); 
   
   SetIndexBuffer(0,diffBuffer,INDICATOR_DATA);
   
   //--- Set as an empty value 0
   //1. plotting style index, 2. property id, 3. value to be set
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,-100);    
   
   printf("jjmaHandle: %d", jjmaHandle);
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
                const int &spread[]) {
   
   
   if(rates_total < minRequiredBarNumber) {
      return (0);
   }
   
   // index everything as time series, time[0] is the most recent 
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(time,true);   
   
   
   
    CopyBuffer(jjmaHandle,0, 0, rates_total - prev_calculated , jjmaBuffer);
    
    
   for(int i=0;i<rates_total - prev_calculated - 1;i++) {
      
      diffBuffer[i] =  jjmaBuffer[i] - jjmaBuffer[i+1];
    
    
   }    
    
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
}

void OnTimer() {


   
}


