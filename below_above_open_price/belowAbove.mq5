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
   EventSetTimer(60);
   
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

bool isNewBar() {
   
   static ENUM_TIMEFRAMES periodName = Period();
   ENUM_TIMEFRAMES thisPeriodName = Period();
   static double totalBar = 0;
   
   if(thisPeriodName != periodName) {
      // period changed
      // reset total bar count
      totalBar = 0;
   }
   
   datetime theTimes[];
   CopyTime(NULL,NULL,0,1,theTimes);
   
   double currentBar = MathFloor( theTimes[0] / PeriodSeconds());
   if(currentBar > totalBar) {
      // new bar
      totalBar = currentBar;
      return true;
   }
   return false;
}

void calculateBasket(double & theBasket[], const double &close[]) {
   double openPrice = getCurrentBarOpenPrice(0);
   double currentPrice = close[0];
   static bool isAbove = false; 
   //printf("openPrice: %G", openPrice);
   //printf("currentPrice: %G", currentPrice);
   if((currentPrice > openPrice) && (currentPrice < openPrice + 30 * Point())){
      theBasket[1] = theBasket[1] + 1;
      //printf("basket[1] add 1: %G", theBasket[1]);    
   }
   if((currentPrice < openPrice) && (currentPrice > openPrice - 30 * Point())) {
      theBasket[2] = theBasket[2] + 1;
   }
   if( (currentPrice >= openPrice + 30 * Point()) && (currentPrice <= openPrice + 50 * Point())) {
      theBasket[0] =  theBasket[0] + 1;
   }
   if( (currentPrice <= openPrice - 30 * Point()) && (currentPrice >= openPrice - 50 * Point())) {
      theBasket[3] =  theBasket[3] + 1;
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
   //calculateFlag(openPrice,close[0],belowAboveBuffer[0], isEqualAboveCurrentOpen);
   
   // calculate counter for previous bar
   //calculateFlag(open[1],close[0],belowAboveBuffer[1], isEqualAbovePreviousOpen);
   //--- return value of prev_calculated for next call
   
   static double basket[4];
   // basket[0]:  +50 * Point()
   // basket[1]:  +30 * Point()
   // basket[2]:  -30 * Point()
   // basket[3]:  -50 * Point()
   
   if(isNewBar()) {
      // 1. print the distribution 
      // 2. reset the arrays
      printf("+50 * Point(): %G", basket[0]);
      printf("+30 * Point(): %G", basket[1]);
      printf("-30 * Point(): %G", basket[2]);
      printf("+50 * Point(): %G", basket[3]);
      printf("---------------  newbar  ------------");
      
      basket[0] = 0;
      basket[1] = 0;
      basket[2] = 0;
      basket[3] = 0;      
   }
   
   calculateBasket(basket, close);
   
   
   
   
   return(rates_total);
}

void OnTimer() {
   
   
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);
   printf("tick.time is: %d", tick.time);
   printf("tick.volume is: %d", tick.volume);
 

   
}

