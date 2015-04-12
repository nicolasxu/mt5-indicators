//+------------------------------------------------------------------+
//|                                                    ema_color.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"
#property indicator_chart_window

//Title: ema 20 on M5 with upward and downward trend color



#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1 DRAW_COLOR_LINE

#property indicator_color1  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width1 3

double indicatorDataBuffer[];
double indicatorColorBuffer[];
int minRequiredBarNumber = 20; // ema period is 20
int jjmaHandle;

int OnInit() {
   
   ArraySetAsSeries(indicatorDataBuffer,true);
   ArraySetAsSeries(indicatorColorBuffer,true);  
   
   SetIndexBuffer(0,indicatorDataBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,indicatorColorBuffer,INDICATOR_COLOR_INDEX);  
   
   jjmaHandle = iCustom(NULL,0,"Expert_Indicators\\jjma", 5, -100, PRICE_OPEN,0,0);              
   printf("jjma Handle: %d", jjmaHandle);
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
   
   if (rates_total < minRequiredBarNumber) {
      return(0);
   }
   CopyBuffer(jjmaHandle,0, 0, rates_total - prev_calculated , indicatorDataBuffer);
   
   for(int i=0;i<rates_total - prev_calculated - 1;i++) {
      // set the color here
      indicatorColorBuffer[i] = 0;
      if(indicatorDataBuffer[i]< indicatorDataBuffer[i+1]) {
         indicatorColorBuffer[i] = 1;
         
      }
      
      if(indicatorDataBuffer[i]> indicatorDataBuffer[i+1]) {
         indicatorColorBuffer[i] = 2;
       
      }
      
   }
   
   //--- return value of prev_calculated for next call
   // so in this function call, we should calculate everything from 0 bar to this current bar
   return(rates_total);
  }


void OnTimer(){

   
}

