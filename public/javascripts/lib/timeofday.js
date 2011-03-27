/**
 * These helpers are fairly specific to the US.
 */
;(function() {
  var $P = Date.prototype
  
  /**
   * Determines if the time is during the daylight hours of 6am-5pm
   */
  $P.isDaylight = function() {
    return this.getHours() >= 6 && this.getHours() < 18
  };
  
  /**
   * Determines if the time is during the dark hours of 5pm-6am
   */
  $P.isDark = function() {
    return this.getHours() >= 18 || this.getHours() < 6
  };
  
  /**
   * Determines if this time is Friday or Saturday night during the hours of 8pm-2am
   */
  $P.isWeekendNightlife = function() {
    return (this.getDay() == 5 || this.getDay() == 6) && (this.getTime() >= 20 || this.getTime() <= 2)
  };
})();