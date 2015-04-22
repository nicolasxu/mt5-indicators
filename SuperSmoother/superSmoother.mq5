//+------------------------------------------------------------------+
//|                                                superSmoother.mq5 |
//|                                                        NicolasXu |
//|                                       https://www.noWebsite5.com |
//+------------------------------------------------------------------+
#property copyright "NicolasXu"
#property link      "https://www.noWebsite5.com"
#property version   "1.00"


#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1 DRAW_COLOR_LINE

#property indicator_color1  clrYellow,clrLime,clrRed,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_width1 2

// Super Smoother introduced by John F.

// M_E: e
// cosin: MathCos

int     ssPeriod = 10; // calculation period, 3 is 3 bars.

int minBarNumber = 2; // calculation starts at 3rd

// buffer
double dataBuffer[];
double colorBuffer[];
double smoothed[];


int OnInit() {
   MqlDateTime dt;
   TimeCurrent(dt);
   printf("Super Smoother initializing... %d", dt.sec  );
   SetIndexBuffer(0,dataBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,colorBuffer,INDICATOR_COLOR_INDEX); 



   
//---
   return(INIT_SUCCEEDED);
}

void superSmoother(const double &inputData[], double &outputData[], int count ) {

   double coeA = MathPow(M_E,-1.414*3.14159/ssPeriod);
   double coeB = 2*coeA*MathCos(1.414*180/ssPeriod);
   double coeC2 = coeB;
   double coeC3 = -coeA*coeA;
   double coeC1 = 1 - coeC2 - coeC3;
   
   ArrayResize(outputData, count);
  

   for(int i=0;i<count; i++){
      
      if(i < minBarNumber) {
         outputData[i] = inputData[i];
      }
      if(i >= minBarNumber){
         outputData[i] = coeC1 * (inputData[i] + inputData[i-1]) / 2 + coeC2 * outputData[i-1] + coeC3 * outputData[i-2];         
      }
   }
}


void addColor(const double &inputData[], double &outputData[], int count) {

   for(int i=0;i<count; i++) {
      
      outputData[i] = 0;
      if(i >= minBarNumber) {

         if(inputData[i]< inputData[i-1]) {
            outputData[i] = 1;
         }
         
         if(inputData[i]> inputData[i-1]) {
            outputData[i] = 2;
         }
      }
   }
}

void decycle(const double &inputData[], double &outputData[], int count) {
   int cutOff = 60;
   int delay = 2; // counts, start at 1
   double alpha = (MathCos(360/cutOff) + MathSin(360/cutOff) - 1) / MathCos(360/cutOff);
   printf("alpha is: %G", alpha);
   /*
   for(int i=0;i<count;i++){
      printf("input[%d]: %G", i, inputData[i]);   
   }
   */
   for(int i=0; i<count; i++) {
      if(i < delay - 1) {
         outputData[i] = inputData[i];
      }
      if(i >= delay - 1) {
     
         outputData[i] = (alpha / 2)*(inputData[i] + inputData[i-1]) + (1- alpha)*outputData[i-1];
         //outputData[i] = ((alpha/2)*(1 + inputData[i-1])) / (1 - (1-alpha)*inputData[i-1]);
         if(i == 200) {
            printf("(alpha / 2)*(inputData[i] + inputData[1]) = %G", (alpha / 2)*(inputData[i] + inputData[1]));
            printf("outputData[i-1]: %G",  outputData[i-1]);
            printf("(1- alpha)*outputData[i-1] = %G", (1- alpha)*outputData[i-1]);
            printf("outputData[%d]: %G", i, outputData[i]);
         }         
         
      }
   }
   
   for(int i=0;i<count;i++){
      if(i % 10000 == 0){
        // printf("outputData[%d]: %G", i, outputData[i]); 
      }
        
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
                const int &spread[]) {

   // 1st, 2nd value is just the input price
   
   if(rates_total < minBarNumber) {
      return (0);
   }
   
   // 1. smooth it
   superSmoother(open, dataBuffer, rates_total - prev_calculated);
   // 2. decycle it
   //decycle(open, dataBuffer, rates_total - prev_calculated);
   // 3. color it
   addColor(dataBuffer,colorBuffer, rates_total - prev_calculated);
   
   /*
   // calculate the data
   for(int i=0;i<rates_total - prev_calculated; i++){
      
      if(i < minBarNumber) {
         dataBuffer[i] = open[i];
      }
      if(i >= minBarNumber){
         dataBuffer[i] = coeC1 * (open[i] + open[i-1]) / 2 + coeC2 * dataBuffer[i-1] + coeC3 * dataBuffer[i-2];         
      }
   }
   // calculate the color
   for(int i=0;i<rates_total - prev_calculated; i++) {
      
      colorBuffer[i] = 0;
      if(i >= minBarNumber) {


         if(dataBuffer[i]< dataBuffer[i-1]) {
            colorBuffer[i] = 1;
         }
         
         if(dataBuffer[i]> dataBuffer[i-1]) {
            colorBuffer[i] = 2;
         }
      }
   }
   */
   return(rates_total);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {


   
}

