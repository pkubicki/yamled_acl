module YamledAcl

  class Error < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  class UninitializedResource < Error
    def initialize
      super("Resource name hasn't been given!")
    end
  end

  class UninitializedGroup < Error
    def initialize
      super("User group hasn't been initialized!")
    end
  end

  class NotExistingGroup < Error
    def initialize
      super("Not existing group!")
    end
  end

  class AccessDenied < Error
    def initialize
      super("You don't have permission to perform this action.")
    end
  end

end
