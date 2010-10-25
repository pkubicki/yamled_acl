module RubikAcl

  class Error < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  class UninitializedResource < Error
    def initialize
      super("Resource name hasn't been given!!!")
    end
  end

  class UninitializedGroup < Error
    def initialize
      super("User group hasn't been initialized!!!")
    end
  end

  class NotExistingGroup < Error
    def initialize
      super("Not existing group!!!")
    end
  end

end
