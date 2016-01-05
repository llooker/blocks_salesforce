- dashboard: marketing_leadership
  title: "Sales & Marketing Leadership"
  layout: tile
  tile_size: 100

  filters:
  
  - name: state
    type: field_filter
    explore: account
    field: account.billing_state

  elements:
  
  - name: total_active_customers
    title: 'Total Active Customers'
    type: single_value
    model: salesforce
    explore: account
    measures: [account.count]
    listen:
      state: account.billing_state
    filters:
      account.type: '"Customer"'
    sorts: [account.count desc]
    font_size: medium
    text_color: '#49719a'
    height: 2
    width: 4
    
  - name: total_revenue
    title: 'Total Revenue Closed (Quarter-to-Date)'
    type: single_value
    model: salesforce
    explore: opportunity
    measures: [opportunity.total_revenue]
    filters:
      opportunity.close_date: this quarter
      opportunity.stage_name: '"Closed Won"'
    sorts: [opportunity.total_revenue desc]
    font_size: medium
    text_color: black
    height: 2
    width: 4
    
  - name: average_deal_size
    title: 'Average Deal Size'
    type: single_value
    model: salesforce
    explore: opportunity
    measures: [opportunity.average_deal_style]
    filters:
      opportunity.close_date: this quarter
      opportunity.stage_name: '"Closed Won"'
    sorts: [opportunity.average_deal_style desc]
    font_size: medium
    text_color: black
    height: 2
    width: 4    
  
  - name: lead_to_win_funnel
    title: 'Lead to Win Funnel (Quarter-to-Date)'
    type: looker_column
    model: salesforce
    explore: lead
    measures: [lead.count, opportunity.count_new_business, opportunity.count_new_business_won]
    listen:
      state: lead.state
    filters:
      lead.created_date: this quarter
    sorts: [lead.count desc]
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    colors: ['#635189', '#a2dcf3', '#1ea8df']
    show_value_labels: true
    label_density: 10
    label_color: ['#635189', '#a2dcf3', '#1ea8df']
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    series_labels:
      lead.count: Leads
      opportunity.count_new_business: Opportunities
      opportunity.count_new_business_won: Won Opportunities
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    show_null_labels: false
    show_dropoff: true
    height: 4
    width: 6
    
  - name: deals_closed_by_segment
    title: 'Deals Closed by Segment'
    type: looker_area
    model: salesforce
    explore: opportunity
    dimensions: [opportunity.close_month, account.business_segment]
    pivots: [account.business_segment]
    measures: [opportunity.count]
    filters:
      opportunity.close_month: before tomorrow
      opportunity.stage_name: '"Closed Won"'
    sorts: [opportunity.close_month, account.business_segment, account.business_segment__sort_]
    limit: 500
    column_limit: 50
    stacking: normal
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
    interpolation: linear
    height: 4
    width: 6

  - name: prospects_by_forecast_category_and_segment
    title: 'Prospects by Forecast Category and Segment'
    type: looker_donut_multiples
    model: salesforce
    explore: opportunity
    dimensions: [account.business_segment, opportunity.forecast_category]
    pivots: [opportunity.forecast_category]
    measures: [account.count]
    filters:
      account.business_segment: -Unknown
      opportunity.stage_name: -%Closed%
    sorts: [opportunity.close_month, account.business_segment, account.business_segment__sort_,
      opportunity.forecast_category]
    limit: 500
    column_limit: 50
    show_value_labels: false
    font_size: 12
    show_view_names: true
    height: 4
    width: 6
    
  - name: sales_segment_performance
    title: 'Sales Segment Performance'
    type: looker_column
    model: salesforce
    explore: opportunity
    dimensions: [account.business_segment]
    measures: [account.count_customers, opportunity.total_revenue]
    filters:
      account.business_segment: -Unknown
      opportunity.stage_name: '"Closed Won"'
    sorts: [opportunity.close_month, account.business_segment, account.business_segment__sort_]
    limit: 500
    column_limit: 50
    stacking: ''
    colors: ['#62bad4', '#a9c574', '#929292', '#9fdee0', '#1f3e5a', '#90c8ae', '#92818d',
      '#c5c6a6', '#82c2ca', '#cee0a0', '#928fb4', '#9fc190']
    show_value_labels: true
    label_density: 25
    font_size: 12
    hide_legend: true
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axis_combined: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_orientation: [left, right]
    show_null_labels: false
    