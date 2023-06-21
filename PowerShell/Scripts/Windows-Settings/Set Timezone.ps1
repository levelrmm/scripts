<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
   Set the timezone.  Here is the list of avilable timezones:
    -12:00:00     Dateline Standard Time
    -11:00:00     UTC-11
    -10:00:00     Hawaiian Standard Time
    -10:00:00     Aleutian Standard Time
    -09:30:00     Marquesas Standard Time
    -09:00:00     UTC-09
    -09:00:00     Alaskan Standard Time
    -08:00:00     Pacific Standard Time
    -08:00:00     UTC-08
    -08:00:00     Pacific Standard Time (Mexico)
    -07:00:00     Mountain Standard Time
    -07:00:00     Yukon Standard Time
    -07:00:00     US Mountain Standard Time
    -07:00:00     Mountain Standard Time (Mexico)
    -06:00:00     Central Standard Time (Mexico)
    -06:00:00     Canada Central Standard Time
    -06:00:00     Easter Island Standard Time
    -06:00:00     Central America Standard Time
    -06:00:00     Central Standard Time
    -05:00:00     Cuba Standard Time
    -05:00:00     US Eastern Standard Time
    -05:00:00     Turks And Caicos Standard Time
    -05:00:00     Haiti Standard Time
    -05:00:00     SA Pacific Standard Time
    -05:00:00     Eastern Standard Time (Mexico)
    -05:00:00     Eastern Standard Time
    -04:00:00     Central Brazilian Standard Time
    -04:00:00     SA Western Standard Time
    -04:00:00     Pacific SA Standard Time
    -04:00:00     Paraguay Standard Time
    -04:00:00     Atlantic Standard Time
    -04:00:00     Venezuela Standard Time
    -03:30:00     Newfoundland Standard Time
    -03:00:00     Magallanes Standard Time
    -03:00:00     Montevideo Standard Time
    -03:00:00     Bahia Standard Time
    -03:00:00     Saint Pierre Standard Time
    -03:00:00     Greenland Standard Time
    -03:00:00     E. South America Standard Time
    -03:00:00     Tocantins Standard Time
    -03:00:00     Argentina Standard Time
    -03:00:00     SA Eastern Standard Time
    -02:00:00     Mid-Atlantic Standard Time
    -02:00:00     UTC-02
    -01:00:00     Cape Verde Standard Time
    -01:00:00     Azores Standard Time
    00:00:00      Sao Tome Standard Time
    00:00:00      Morocco Standard Time
    00:00:00      Greenwich Standard Time
    00:00:00      UTC
    00:00:00      GMT Standard Time
    01:00:00      Central European Standard Time
    01:00:00      W. Central Africa Standard Time
    01:00:00      Romance Standard Time
    01:00:00      W. Europe Standard Time
    01:00:00      Central Europe Standard Time
    02:00:00      South Sudan Standard Time
    02:00:00      Israel Standard Time
    02:00:00      FLE Standard Time
    02:00:00      Kaliningrad Standard Time
    02:00:00      Namibia Standard Time
    02:00:00      Libya Standard Time
    02:00:00      Sudan Standard Time
    02:00:00      Egypt Standard Time
    02:00:00      Middle East Standard Time
    02:00:00      GTB Standard Time
    02:00:00      E. Europe Standard Time
    02:00:00      South Africa Standard Time
    02:00:00      West Bank Standard Time
    02:00:00      Syria Standard Time
    03:00:00      Russian Standard Time
    03:00:00      Belarus Standard Time
    03:00:00      Volgograd Standard Time
    03:00:00      E. Africa Standard Time
    03:00:00      Arabic Standard Time
    03:00:00      Jordan Standard Time
    03:00:00      Arab Standard Time
    03:00:00      Turkey Standard Time
    03:30:00      Iran Standard Time
    04:00:00      Saratov Standard Time
    04:00:00      Mauritius Standard Time
    04:00:00      Caucasus Standard Time
    04:00:00      Georgian Standard Time
    04:00:00      Astrakhan Standard Time
    04:00:00      Arabian Standard Time
    04:00:00      Russia Time Zone 3
    04:00:00      Azerbaijan Standard Time
    04:30:00      Afghanistan Standard Time
    05:00:00      Pakistan Standard Time
    05:00:00      Qyzylorda Standard Time
    05:00:00      West Asia Standard Time
    05:00:00      Ekaterinburg Standard Time
    05:30:00      Sri Lanka Standard Time
    05:30:00      India Standard Time
    05:45:00      Nepal Standard Time
    06:00:00      Omsk Standard Time
    06:00:00      Bangladesh Standard Time
    06:00:00      Central Asia Standard Time
    06:30:00      Myanmar Standard Time
    07:00:00      North Asia Standard Time
    07:00:00      N. Central Asia Standard Time
    07:00:00      Tomsk Standard Time
    07:00:00      SE Asia Standard Time
    07:00:00      Altai Standard Time
    07:00:00      W. Mongolia Standard Time
    08:00:00      W. Australia Standard Time
    08:00:00      Taipei Standard Time
    08:00:00      Ulaanbaatar Standard Time
    08:00:00      China Standard Time
    08:00:00      North Asia East Standard Time
    08:00:00      Singapore Standard Time
    08:45:00      Aus Central W. Standard Time
    09:00:00      Korea Standard Time
    09:00:00      Yakutsk Standard Time
    09:00:00      North Korea Standard Time
    09:00:00      Transbaikal Standard Time
    09:00:00      Tokyo Standard Time
    09:30:00      AUS Central Standard Time
    09:30:00      Cen. Australia Standard Time
    10:00:00      Tasmania Standard Time
    10:00:00      Vladivostok Standard Time
    10:00:00      West Pacific Standard Time
    10:00:00      E. Australia Standard Time
    10:00:00      AUS Eastern Standard Time
    10:30:00      Lord Howe Standard Time
    11:00:00      Norfolk Standard Time
    11:00:00      Sakhalin Standard Time
    11:00:00      Central Pacific Standard Time
    11:00:00      Bougainville Standard Time
    11:00:00      Russia Time Zone 10
    11:00:00      Magadan Standard Time
    12:00:00      Fiji Standard Time
    12:00:00      Kamchatka Standard Time
    12:00:00      UTC+12
    12:00:00      Russia Time Zone 11
    12:00:00      New Zealand Standard Time
    12:45:00      Chatham Islands Standard Time
    13:00:00      Samoa Standard Time
    13:00:00      Tonga Standard Time
    13:00:00      UTC+13
    14:00:00      Line Islands Standard Time
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Change the timezone here to your desired timezone
$timezone = "Eastern Standard Time"

#Set the timezone and force a time sync
Set-TimeZone -Id $timezone
W32tm /resync /force