defmodule Rfc2282 do
  def current_timestamp do
    {{year, month, day}, {hour, minute, second}} = nowtime()
    day_of_week = :calendar.day_of_the_week(year, month, day)

    "#{daylist(day_of_week)}, #{day} #{monthlist(month)} #{year} #{hour}:#{minute}:#{second} -0000"
  end

  defp nowtime do
    :calendar.universal_time()
  end

  defp daylist(day_num) do
    %{
      1 => "Mon",
      2 => "Tue",
      3 => "Wed",
      4 => "Thu",
      5 => "Fri",
      6 => "Sat",
      7 => "Sun"
    }[day_num]
  end

  defp monthlist(month_num) do
    %{
      1 => "Jan",
      2 => "Feb",
      3 => "Mar",
      4 => "Apr",
      5 => "May",
      6 => "Jun",
      7 => "Jul",
      8 => "Aug",
      9 => "Sep",
      10 => "Oct",
      11 => "Nov",
      12 => "Dec"
    }[month_num]
  end
end
