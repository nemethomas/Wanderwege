import logging
import azure.functions as func

def example_function():

        # Calculation
    a = 5
    b = 10
    result = a + b
    
    # Logging
    logging.info(f"Demo Calculation: {a} + {b} = {result}")
    
    # Logging current time
    logging.info("Current time: %s", str(datetime.datetime.now()))
    
    # Logging
    logging.info("Succesfully executed.")
    
    logging.info("Die example_function wurde ausgeführt.")
    return "Hello from example_function!"

def main(timer: func.TimerRequest) -> None:
    """
    Die Hauptfunktion, die bei einem Timer-Trigger von Azure Functions aufgerufen wird.
    """
    utc_timestamp = timer.schedule_status.last
    logging.info(f"Timer trigger executed at {utc_timestamp}")

    # Rufe die example_function auf
    result = example_function()
    logging.info(f"example_function hat folgendes zurückgegeben: {result}")
