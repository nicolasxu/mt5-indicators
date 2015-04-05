//+------------------------------------------------------------------+
//|                                                   belowAbove.mq5 |
//|                                                       Nicolas Xu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Nicolas Xu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 300
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  4


double belowAboveBuffer[]; // main buffer for holding the drawing data
int minRequiredBarNumber = 0;
bool isEqualAboveCurrentOpen = false;
bool isEqualAbovePreviousOpen = false;

double getCurrentBarOpenPrice(ENUM_TIMEFRAMES timeframe) {
   double openArray[1] = {0};
   CopyOpen (Symbol(), timeframe, 0, 1, openArray);
   return openArray[0];
}

int OnInit(){
   //--- indicator buffers mapping
   SetIndexBuffer(0,belowAboveBuffer,INDICATOR_DATA);
   
   ArraySetAsSeries(belowAboveBuffer,true);
   
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0); 
   
   return(INIT_SUCCEEDED);
}

void calculateFlag(double openPrice, double currentPrice, double & counter, bool & isEqualAboveOpen) {
   if(currentPrice >= openPrice){
      if(isEqualAboveOpen) {
         // do nothing   
      } else {
         counter = counter +1;
      }
      isEqualAboveOpen = true;
   } else {
     if(isEqualAboveOpen){
         counter = counter +1;  
     } else {
         // do nothing
     }
     isEqualAboveOpen = false;
   }
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
   
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(open,true);
   
   double openPrice = getCurrentBarOpenPrice(0);
   
   // calculate counter for current bar
   calculateFlag(openPrice,close[0],belowAboveBuffer[0], isEqualAboveCurrentOpen);
   
   // calculate counter for previous bar
   calculateFlag(open[1],close[0],belowAboveBuffer[1], isEqualAbovePreviousOpen);
   //--- return value of prev_calculated for next call
   return(rates_total);
}

void OnTimer() {

   
}

