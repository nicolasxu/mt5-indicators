//+------------------------------------------------------------------+
//|                                                 trix_osc_col.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"
#property indicator_separate_window
//#property indicator_minimum -0.0002
//#property indicator_maximum 0.0002
#property indicator_buffers 2
#property indicator_plots 1
#property indicator_type1 DRAW_COLOR_LINE
#property indicator_color1  clrLime, clrRed, clrYellow
 
#property indicator_style1 STYLE_SOLID

#property indicator_width1 3


double dataBuffer[];
double colorBuffer[];
int trixHandle;




//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
//--- indicator buffers mapping

   trixHandle =  iTriX(NULL, // symbol name
                          0, // period
                         14, // averaging period
                 PRICE_CLOSE // type of price or handle
   );
   printf("trixHandle is: %d", trixHandle);
   if(trixHandle==INVALID_HANDLE) {
   //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iTriX indicator for the symbol %s/%s, error code name",
         EnumToString(Period()),
         GetLastError()
      );
      //--- the indicator is stopped early
      return(INIT_FAILED);
   }
   ArraySetAsSeries(dataBuffer, true);
   ArraySetAsSeries(colorBuffer, true);
   
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,-100); 
   
   SetIndexBuffer(0,dataBuffer, INDICATOR_DATA);
   SetIndexBuffer(1,colorBuffer, INDICATOR_COLOR_INDEX); 
   
   
  
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

  
   CopyBuffer(trixHandle, 0, 0, rates_total - prev_calculated, dataBuffer);  
   


   for(int i=0;i<rates_total - prev_calculated -1 ;i++) {
      // set the color here
      
      if(dataBuffer[i]< dataBuffer[i+1]) {
         colorBuffer[i] = 1;
         
      }
      
      if(dataBuffer[i]> dataBuffer[i+1]) {
         colorBuffer[i] = 0;
         
      }
   }   
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {

   
}
//+------------------------------------------------------------------+
