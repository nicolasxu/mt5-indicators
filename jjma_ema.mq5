//+------------------------------------------------------------------+
//|                                                     jjma_ema.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"

//---- the indicator will be plotted in the main window
#property indicator_chart_window

//---- one buffer will be used for the calculations and plot of the indicator
#property indicator_buffers 2

//---- only one graphic plot is used 
#property indicator_plots   1

#property indicator_type1 DRAW_COLOR_ARROW

#property indicator_color1 clrRed, clrBlue

#property indicator_style1 STYLE_SOLID

#property indicator_width1 1

double ColorArrowBuffer[];
double ColorArrowColors[];
int minRequiredBarNumber = 20; // ema period is 20

int ema20Handle;
int jjma7Handle;
double jjmaBuffer[];
double emaBuffer[];


input ushort arrowSymbolCode = 159;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- indicator buffers mapping
   SetIndexBuffer(0,ColorArrowBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ColorArrowColors,INDICATOR_COLOR_INDEX);
   
   
   //--- Define the symbol code for drawing in PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,arrowSymbolCode);
   
   //--- Set the vertical shift of arrows in pixels
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,0); // no shift
   
   //--- Set as an empty value 0
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0);
   
   //--- set indicator buffer arrays to series
   ArraySetAsSeries(ColorArrowBuffer,true); // ColorArrowBuffer[0] is the most recent
                                            // contains the value where to draw the arrow
   ArraySetAsSeries(ColorArrowColors,true); // contains the value of color
   
   ArraySetAsSeries(jjmaBuffer,true);
   
   //--- init other indicators used in this one
   
     ema20Handle = iMA(  NULL,          // symbol string
                            0,          // timeframe
                           20,          // ma period
                            0,          // ma shift
                           MODE_EMA,    // Smooth method
                          PRICE_CLOSE   // Calculating on Close prices
                 ); 
     jjma7Handle = iCustom(NULL,0,"Expert_Indicators\\jjma", 7, 100, PRICE_CLOSE,0,0);   
     
     printf("ema20Handle: %d", ema20Handle);
     printf("jjma7Handle: %d", jjma7Handle);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,       // number of available bars in history at the current tick
                const int prev_calculated,   // number of bars, calculated at previous tick
                const datetime &time[],      
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   printf("prev_calculated: %d,rates_total: %d ", prev_calculated, rates_total);
   
//--- Get the number of bars available for the current symbol and chart period

   
   
   // don't draw, if no more than 20 bars
   if(rates_total < minRequiredBarNumber){
      return(0);   
   }
   
   // so there are at least 20 bars
   
   // index everything as time series, time[0] is the most recent 
    ArraySetAsSeries(open,true);
    ArraySetAsSeries(close,true);
    ArraySetAsSeries(high,true);
    ArraySetAsSeries(low,true);
    ArraySetAsSeries(time,true);
    
//   int bars=Bars(Symbol(),0);
//   Print("Bars = ",bars,", rates_total = ",rates_total,",  prev_calculated = ",prev_calculated);
//   Print("time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]);    
   
// It's necessary to note that the bars ordering in MetaTrader client terminal is performed from left to right,
// so the very old bar (the left), presented at chart has index 0, the next has index 1, etc   
   
   CopyBuffer(jjma7Handle,0, 0, rates_total - prev_calculated , jjmaBuffer);
   for(int i=0;i<rates_total - prev_calculated - 1;i++) {
      
      if(jjmaBuffer[i] < jjmaBuffer[i+1]){
          ColorArrowColors[i] = 0;
         ColorArrowBuffer[i] = jjmaBuffer[i];
      }
      if(jjmaBuffer[i]> jjmaBuffer[i+1]){
         ColorArrowColors[i] = 1;
         ColorArrowBuffer[i] =  jjmaBuffer[i+1];   
      }
   }
   
   
  
   
   //printf("jjmaBuffer[0] is: %G", jjmaBuffer[0]);
   
  
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
