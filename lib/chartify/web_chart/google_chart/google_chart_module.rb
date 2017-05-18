require 'chartify/bar_chart'

module Chartify
  module WebChart
    module GoogleChart
      module GoogleChartModule
        def chart_options
          {
              title: title,
              backgroundColor: bg_color,
              colors: web_colors,
              vAxis: {baselineColor: baseline_color,
                      gridlines: {color: grid_color},
                      textStyle: {color: text_color}},
              hAxis: {baselineColor: baseline_color,
                      gridlines: {color: grid_color},
                      textStyle: {color: text_color}},
              legend: {textStyle: {color: text_color}},
              lineWidth: config.web_config.line_width
          }
        end

        def array_data_table
          p 'array_data_table'
          array_data = label_column.present? ? [[label_column] + column_names] : [column_names]
          if data.kind_of?(NilClass)
            return []
          end
          array_data + data.collect do |row|
            row_val = column_keys.collect { |col| row[col].to_i }
            label_column.present? ? [row[label_column]] + row_val : row_val
          end

        end

        def timestamp
          @timestamp ||= Time.now.to_i
        end

        def include_js
          %q{<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>}

        end

        def wrap_in_function(code)
          # js = <<-JS
          #   google.load("visualization", "1", {packages:["corechart"], callback:drawChart#{timestamp}});
          #   function drawChart#{timestamp}() {
          #     #{code}
          #   }
          # JS





          js = <<-JS
            function drawChart#{timestamp}() {
            console.log('cargando google')
              #{code}
            }
            google.charts.load('43', {packages: ['corechart']});
            google.charts.setOnLoadCallback(drawChart#{timestamp});
          JS
          js.html_safe
        end
      end
    end
  end
end