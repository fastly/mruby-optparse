class TestOptparse < MTest::Unit::TestCase
  def setup
    @configuration = {}

    @environments = {
      'production'  => 'https://prod.example',
      'staging'     => 'https://stg.example',
      'development' => 'http://dev.example'
    }

    @o = OptionParser.new

    @o.on "--[no-]cleanup",
          "Remove WAF at end of run." do |cleanup|
      @configuration[:CLEANUP] = cleanup
    end

    @o.on_head "--environment=ENVIRONMENT", @environments.keys,
               "Set the environment you want to work with." do |environment|
      @configuration[:ENVIRONMENT] = environment
    end

    @o.on "--array=ITEMS", Array do |array|
      @configuration[:ARRAY] = array
    end

    @o.on "--integer=INTEGER", Integer do |integer|
      @configuration[:INTEGER] = integer
    end

    @o.banner = "Usage: mruby #{__FILE__} [OPTIONS]"
  end

  def test_parse
    @o.parse '--cleanup'

    assert @configuration[:CLEANUP]
  end

  def test_parse_argument_completion
    @o.parse '--clean'

    assert @configuration[:CLEANUP]
  end

  def test_parse_argument_conversion
    @o.parse '--array=1,2,3'

    assert_equal %w[1 2 3], @configuration[:ARRAY]
  end

  def test_parse_argument_validation
    @o.parse '--integer=1'

    assert_equal 1, @configuration[:INTEGER]
  end

  def test_parse_argument_validation_invalid
    assert_raise OptionParser::InvalidArgument do
      @o.parse '--integer=string'
    end
  end

  def test_parse_value_completion
    @o.parse '--environment', 'prod'

    assert_equal 'production', @configuration[:ENVIRONMENT]
  end

  def test_record_separator
    assert_equal "\n", @o.record_separator

    @o.record_separator = "\r\n"

    assert_equal "\r\n", @o.record_separator
  end

  def test_to_s
    help = @o.to_s

    assert_match 'Usage: ',             help
    assert_match '--environment',       help
    assert_match 'Set the environment', help
    assert_match '--[no-]cleanup',      help
  end
end

MTest::Unit.new.run if __FILE__ == $0
