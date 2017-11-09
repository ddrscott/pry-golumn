require 'tempfile'

Pry::Commands.create_command 'golumn', keep_retval: true, use_shellwords: false do |text|
  description 'Send SQL or scope to `psql` and then to `golumn`: golumn Model.all'

  banner <<-BANNER
    Usage: golumn [SQL or Ruby which evaluates to String or a Rails Model]

    Saves SQL to Dir.tmpdir/pry-psql.sql with adds basic formatting.
    Then sends statemnet to `psql` or Rails determined system command.
    Then send CSV data to column.
  BANNER

  def process
    sql = sql_from_args
    output.puts('Executing SQL:', sql)
    { duration: exec_to_golumn(sql) }
  end

  # Parse the Pry args into a SQL statement.
  # The Pry args maybe a Rails statement that generates SQL, so we try
  # called `to_sql` first or `all.to_sql`, otherwise the whole evaled
  # result is considered the SQL.
  def sql_from_args
    # Remove all the flags.
    #   Sample Regex: /\b?\\-[xth]+\s*/
    argless = arg_string.gsub(%r{\b?-[#{opts.options.map(&:short).join}]+\s*}, '')
    evaled = begin
               target.eval(argless)
             rescue Exception
               # If there are any problems evaluating, consider the whole thing as raw SQL
               argless
             end
    evaled.try(:to_sql) || evaled.try(:all).try(:to_sql) || evaled
  end

  def exec_to_golumn(sql)
    conn = ActiveRecord::Base.connection.instance_variable_get(:@connection) || raise("@connection not found! This only works with PG connections or the PG adatper changed. Try using a different way to get the raw PG connection.")
    query_time = Time.current
    copy_cmd = 'COPY (%s) TO STDOUT CSV HEADER'
    tmp_file = File.join(Dir.tmpdir, 'pry-golumn.csv')
    conn.copy_data(copy_cmd % sql) do
      File.open(tmp_file, 'wb') do |f|
        while (row = conn.get_copy_data)
          f << row
        end
      end
    end
    begin
      table_name = sql.tr(%("'), '')[/from\s+(\w+)/i, 1]
    rescue
      table_name = '-'
      output.puts "Could not determine table name. Defaulting to '-'"
    end
    table_name = table_name.blank? ? '-' : table_name
    cmd = "golumn --title #{table_name} #{tmp_file} &"
    output.puts "> #{cmd}"
    system(cmd)
    duration = Time.current - query_time
    (duration * 1000).to_i
  end
end
