require 'nori'

module ApiHelper
  CONTENT_TYPES = {
    json: 'application/json',
    xml: 'application/xml'
  }
  
  def parse_response_json(response)
    data = ActiveSupport::JSON.decode(response)
    
    create_result_obj(data)
  end
  
  def parse_response_xml(response)
    parser = Nori.new
    data = parser.parse(response)
    
    data && data.length>0 ? create_result_obj(data.to_a[0][1]) : nil
  end
  
  def create_result_obj(data)
    columns = []
    rows = []
    if data && ((Array===data && !data.empty?) || (Hash===data && data = [data]))
      data.each do |row|
        row_to_insert = []
        row.each_pair do |column, value|
          columns << column unless columns.include? column
          row_to_insert << value
        end
        rows << row_to_insert
      end
    end
    
    { rows: rows, columns: columns, data: data }
  end
  
  def check_response_data(res, real_res)
    assert res, res
    assert res[:columns], res
    assert res[:rows], res
    
    if res[:columns].length>0
      assert_equal real_res.columns.length, res[:columns].length, print_failure_data(real_res.columns, res[:columns])
    end
    assert_equal real_res.rows.length, res[:rows].length, print_failure_data(real_res.rows, res[:rows])
    res[:columns].each_index do |i|
      assert_equal real_res.columns[i], res[:columns][i], res[:columns]
    end
    
    res[:rows].each_index do |i|
      res[:rows][i].each_index do |j|
        assert_equal real_res.rows[i][j].to_s, res[:rows][i][j].to_s
      end
    end
  end
  
  def print_failure_data(real, from_api)
    "Real result: #{real}\nApi sent: #{from_api}"
  end
end
