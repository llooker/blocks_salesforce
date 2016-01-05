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
  
  #Total ACV This Quarter - not possible
  #New MRR This Quarter - not possible
  
  - name: add_a_unique_name_1452027563584
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
    limit: 500
    column_limit: 50
    font_size: medium
    text_color: '#49719a'
  
  - name: add_a_unique_name_1452028024635
    title: 'Lead to Win Funnel'
    type: looker_column
    model: salesforce
    explore: lead
#     measures: [lead.count, meeting.count, opportunity.count, opportunity.count_won]
    measures: [lead.count, opportunity.count_new_business, opportunity.count_new_business_won]
    listen:
      state: lead.state
    filters:
      lead.created_date: 9 months
    sorts: [lead.count desc]
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
#     colors: ['#635189', '#b3a0dd', '#a2dcf3', '#1ea8df']
    colors: ['#635189', '#a2dcf3', '#1ea8df']
    show_value_labels: true
    label_density: 10
#     label_color: ['#635189', '#b3a0dd', '#a2dcf3', '#1ea8df']
    label_color: ['#635189', '#a2dcf3', '#1ea8df']
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    series_labels:
      lead.count: Leads
#       meeting.count: Meetings
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
    
  # Won Opportunities by Business Segment Over Time - not possible?
  
  