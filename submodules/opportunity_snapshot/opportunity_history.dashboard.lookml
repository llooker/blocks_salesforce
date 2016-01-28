- dashboard: opportunity_history
  title: Opportunity History
  layout: tile
  tile_size: 100

  elements:

  - name: quarterly_pipeline_development_report
    title: 'Quarterly Pipeline Development Report'
    type: looker_area
    model: salesforce
    explore: historical_snapshot
    dimensions: [historical_snapshot.snapshot_date, historical_snapshot.probability_tier]
    pivots: [historical_snapshot.probability_tier]
    measures: [historical_snapshot.total_amount]
    filters:
      historical_snapshot.close_date: 2015/10/01 to 2016/01/01
      historical_snapshot.snapshot_date: 2015/04/01 to 2016/01/01
      historical_snapshot.stage_name_funnel: Won,Winning,Trial,Prospect
    sorts: [historical_snapshot.snapshot_date, historical_snapshot.snapshot_month desc,
      historical_snapshot.close_month, historical_snapshot.stage_name_funnel__sort_,
      historical_snapshot.probability_tier, historical_snapshot.probability_tier__sort_]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: normal
    colors: [black, '#1FD110', '#95d925', '#d0ca0e', '#c77706', '#bf2006', lightgrey,
      black]
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    hidden_series: [20 - 39%, 1 - 19%]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    reference_lines: [{reference_type: line, range_start: max, range_end: min, margin_top: deviation,
        margin_value: mean, margin_bottom: deviation, line_value: '7200000', label: Goal ($7.2M),
        color: purple}]
    point_style: none
    interpolation: linear
      
  - name: historical_pipeline_snapshot
    title: 'Historical Pipeline Snapshot'
    type: looker_area
    model: salesforce
    explore: historical_snapshot
    dimensions: [historical_snapshot.snapshot_date, historical_snapshot.stage_name_funnel]
    pivots: [historical_snapshot.stage_name_funnel]
    measures: [historical_snapshot.total_amount]
    filters:
      historical_snapshot.snapshot_date: 365 days
      historical_snapshot.stage_name_funnel: -Won,-Lost,-Unknown
    sorts: [historical_snapshot.snapshot_date desc, historical_snapshot.stage_name_funnel desc,
      historical_snapshot.stage_name_funnel__sort_]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: normal
    colors: ['#7FCDAE', '#85D67C', '#CADF79', '#E7AF75', '#EB9474', '#EE7772']
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    point_style: none
    interpolation: step
  
    
    