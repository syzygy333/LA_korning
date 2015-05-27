# Use this file to import the sales information into the
# the database.

require "pg"
require "CSV"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  employee_array = []
  customer_array = []
  frequency_array = []
  product_array = []

  CSV.foreach("sales.csv", :headers => true) do |csv_row|
    unless employee_array.include?(csv_row['employee'])
      employee_array << csv_row['employee']
    end
    unless customer_array.include?(csv_row['customer_and_account_no'])
      customer_array << csv_row['customer_and_account_no']
    end
    unless frequency_array.include?(csv_row['invoice_frequency'])
      frequency_array << csv_row['invoice_frequency']
    end
    unless product_array.include?(csv_row['product_name'])
      product_array << csv_row['product_name']
    end
  end

  employee_array.each do |employee|
    conn.exec_params("INSERT INTO sellers (employee) VALUES ($1)", [employee])
  end
  customer_array.each do |customer|
    conn.exec_params("INSERT INTO buyers (cust_acct) VALUES ($1)",[customer])
  end
  frequency_array.each do |frequency|
    conn.exec_params("INSERT INTO invoice_freq (frequency) VALUES ($1)", [frequency])
  end
  product_array.each do |product|
    conn.exec_params("INSERT INTO products (product) VALUES ($1)", [product])
  end

  CSV.foreach("sales.csv", :headers => true) do |csv_row|
    employee_id = conn.exec_params("SELECT id FROM sellers WHERE employee = $1", [csv_row['employee']]).to_a
    customer_id = conn.exec_params("SELECT id FROM buyers WHERE cust_acct = $1", [csv_row['customer_and_account_no']]).to_a
    frequency_id = conn.exec_params("SELECT id FROM invoice_freq WHERE frequency = $1", [csv_row['invoice_frequency']]).to_a
    product_id = conn.exec_params("SELECT id FROM products WHERE product = $1", [csv_row['product_name']]).to_a
    conn.exec_params("INSERT INTO invoices
    (inv_num, sale_date, product, units, sale_amount, seller_id, cust_id, freq_id)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
    [csv_row['invoice_no'],csv_row['sale_date'], product_id[0]['id'].to_i, csv_row['units_sold'],
    csv_row['sale_amount'], employee_id[0]['id'].to_i, customer_id[0]['id'].to_i, frequency_id[0]['id'].to_i])
  end
end
