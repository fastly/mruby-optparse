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
               "Set the environment you want to work with.",
               "\n",
               "Valid values:",
               "  #{@environments.keys.join ', '}",
               "\n",
               "Defaults to production." do |environment|
      @configuration[:ENVIRONMENT] = environment
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

  def test_parse_value_completion
    @o.parse '--environment', 'prod'

    assert_equal 'production', @configuration[:ENVIRONMENT]
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
