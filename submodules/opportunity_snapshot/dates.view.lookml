

# Derived table of numbers and dates (Redshift Implementation)

- view: two_numbers
  derived_table:
    sql: SELECT 1 as num UNION SELECT 2 as num
    persist_for: 500 hours
    sortkeys: num
    
- view: numbers
  derived_table: 
    persist_for: 500 hours
    sortkeys: [number]
    sql: |
        SELECT 
          ROW_NUMBER() OVER (ORDER BY a2.num ) as number
        FROM ${two_numbers.SQL_TABLE_NAME} as a2,
            ${two_numbers.SQL_TABLE_NAME} as a4,
             ${two_numbers.SQL_TABLE_NAME} as a8,
             ${two_numbers.SQL_TABLE_NAME} as a16,
             ${two_numbers.SQL_TABLE_NAME} as a32,
             ${two_numbers.SQL_TABLE_NAME} as a64,
             ${two_numbers.SQL_TABLE_NAME} as a128,
             ${two_numbers.SQL_TABLE_NAME} as a256,
             ${two_numbers.SQL_TABLE_NAME} as a512,
             ${two_numbers.SQL_TABLE_NAME} as a1024,
             ${two_numbers.SQL_TABLE_NAME} as a2048,
             ${two_numbers.SQL_TABLE_NAME} as a4096,
             ${two_numbers.SQL_TABLE_NAME} as a8192,
             ${two_numbers.SQL_TABLE_NAME} as a16384,
             ${two_numbers.SQL_TABLE_NAME} as a32768,
             ${two_numbers.SQL_TABLE_NAME} as a65535,
             ${two_numbers.SQL_TABLE_NAME} as a131072,
             ${two_numbers.SQL_TABLE_NAME} as a262144
    
  fields:
  - dimension: number
    primary_key: true
    type: int

- view: dates
  derived_table:
    persist_for: 500 hours
    sortkeys: [date]
    sql: |
      SELECT DATE('1970-01-01') + number as date FROM ${numbers.SQL_TABLE_NAME} as numbers
      
  fields:
  - dimension_group: event
    type: time
    timeframes: [date, week, month, year]
    convert_tz: false
    sql: ${TABLE}.date
    
  