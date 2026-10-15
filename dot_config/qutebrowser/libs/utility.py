def to_bool(value) -> bool:
    if value == "true":
        return True
    elif value == "True":
        return True
    elif value == "false":
        return False
    elif value == "False":
        return False
    elif value == 0:
        return False
    elif value == 1:
        return True
    else:
        raise ValueError("Value was not recognized as a valid Boolean.")
