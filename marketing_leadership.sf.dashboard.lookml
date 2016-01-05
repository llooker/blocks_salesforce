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



