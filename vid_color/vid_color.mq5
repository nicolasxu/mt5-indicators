//+------------------------------------------------------------------+
//|                                                    vid_color.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"
#property indicator_chart_window

// put up and down color on default Variable Index Dynamic Average

#property  indicator_buffers 2
#property  indicator_plots 1
#property  indicator_type1 DRAW_COLOR_LINE
#property  indicator_color1 clrLime, clrRed, clrYellow
#property indicator_width1 3


double dataFinalBuffer[];
double dataAfterVid[];
double colorBuffer[];
int vidaHandle;



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
   vidaHandle = iVIDyA(NULL,0,
                            9, // 
                           12,
                            0, 
                 PRICE_CLOSE);
   printf("vidaHandle is: %d", vidaHandle);
   
   if(vidaHandle==INVALID_HANDLE) {
   //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iTriX indicator for the symbol %s/%s, error code name",
         EnumToString(Period()),
         GetLastError()
      );
      //--- the indicator is stopped early
      return(INIT_FAILED);
   }   
   
   ArraySetAsSeries(dataFinalBuffer, true);
   ArraySetAsSeries(dataAfterVid, true);
   ArraySetAsSeries(colorBuffer, true);
   
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,-100);  
   
   SetIndexBuffer(0,dataFinalBuffer, INDICATOR_DATA);
   SetIndexBuffer(1,colorBuffer, INDICATOR_COLOR_INDEX);      
   

   return(INIT_SUCCEEDED);
}



void superSmoother(const double &inputData[], double &outputData[], int prev_calculated, int rates_total ) {
   
   int minBarNumber = 2;
   int    ssPeriod = 8; // calculation period, 3 is 3 bars.
   double coeA = MathPow(M_E,-1.414*3.14159/ssPeriod);
   double coeB = 2*coeA*MathCos(1.414*180/ssPeriod);
   double coeC2 = coeB;
   double coeC3 = -coeA*coeA;
   double coeC1 = 1 - coeC2 - coeC3;
   
   ArrayResize(outputData, rates_total);
  

   for(int i = rates_total - prev_calculated - 1; i>=0 ; i--){
      if(i > 100500) {
         //printf("inputData[%d]: %G", i, inputData[i]);
      }
      
      if(i > rates_total - minBarNumber-1 -11) {
         printf("i is: %d", i);
         outputData[i] = inputData[i];
      }
      if(i <= rates_total - minBarNumber-1 -11){
         
         outputData[i] = coeC1 * (inputData[i] + inputData[i+1]) / 2 + coeC2 * outputData[i+1] + coeC3 * outputData[i+2];         
      }
   }
}

void addColor(const double &inputData[], double &outputData[], int prev_calculated, int rates_total) {
   int minBarNumber = 1;
   for(int i=prev_calculated;i<rates_total; i++) {
      
      outputData[i] = 0;
      if(i >= minBarNumber) {

         if(inputData[i]< inputData[i-1]) {
            outputData[i] = 0;
         }
         
         if(inputData[i]> inputData[i-1]) {
            outputData[i] = 1;
         }
      }
   }
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
                
   if(BarsCalculated(vidaHandle)<rates_total) return(0);
   
   int to_copy= 0;
   
   if(prev_calculated > rates_total || prev_calculated <=0) {
      to_copy = rates_total - 11;
   }else {
      to_copy = rates_total - prev_calculated;
      to_copy++;
   } 
  
   
   
   
   int copied = CopyBuffer(vidaHandle, 0, 0, to_copy , dataFinalBuffer);
   if(copied < 0 ) {
      printf("copy buffer failed;");
      return rates_total;
   }
   //printf("dataAfterVid[3]: %G",dataAfterVid[rates_total -1] );
  // superSmoother(dataAfterVid, dataFinalBuffer, prev_calculated, rates_total);
   
 //  addColor(dataFinalBuffer,colorBuffer,prev_calculated,rates_total);
   
   
   
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
