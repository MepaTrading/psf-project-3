//+------------------------------------------------------------------+
//|   custom indicator - simple moving average                       |
//+------------------------------------------------------------------+

#property link "https://github.com/MepaTrading/psf-project-3"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_width1 3
#property indicator_style1 STYLE_SOLID
#property indicator_color1  Red
input int period = 13;         // Period
input int shift = 0;           // Shift

double ExtLineBuffer[];

void CalculateSimpleMA(int rates_total,int prev_calculated,int begin,const double &price[]) {
   int i, limit;
   if(prev_calculated == 0) {
      limit = period + begin;

      for(i = 0; i < limit - 1; i++) { 
          ExtLineBuffer[i]=0.0;
      }

      double firstValue = 0;

      for(i = begin; i < limit;) {
         firstValue += price[i++];
      }

      firstValue /= period;
      ExtLineBuffer[limit - 1] = firstValue;
    } else { 
       limit = prev_calculated - 1;
    }
   for(i = limit; i < rates_total && !IsStopped(); i++) {
      ExtLineBuffer[i] = ExtLineBuffer[i-1] + (price[i] - price[i-period]) / period;
   }
}

void OnInit() {
   SetIndexBuffer(0, ExtLineBuffer, INDICATOR_DATA);
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits+1);
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, period);
   PlotIndexSetInteger(0, PLOT_SHIFT, shift);
   IndicatorSetString(INDICATOR_SHORTNAME, "Simple moving average");
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
}


int OnCalculate(const int rates_total, const int prev_calculated, const int begin, const double &price[]) {
   if(rates_total < period - 1 + begin) {
      return 0;
   }
   if(prev_calculated == 0) {
      ArrayInitialize(ExtLineBuffer, 0);
   }

   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, period - 1 + begin);

   CalculateSimpleMA(rates_total, prev_calculated, begin, price);

   return rates_total;
}
