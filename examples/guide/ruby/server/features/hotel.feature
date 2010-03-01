Feature: Hotel
  In order to value
  As a role
  I want feature

  Scenario Outline: title
    Given the following hotels exist:
		|  name  |  city  |  room_count  |  rate  |
		| <name> | <city> | <room_count> | <rate> |
    When I create a resource using <content_type>
		Then the response should be valid
		And the hotel name should be "<name>"
		And the hotel city should be "<city>"
		And the hotel room_count should be "<room_count>"
		And the hotel rate should be "<rate>"

		Examples:
			| name                 | city      |room_count | rate | content_type         |
			| Caelum Objects Hotel | Sao Paulo | 3         | 4    | application/xml      |
			| Restfulie Hotel      | Sao Paulo | 12        | 5    | vnd/caelum_hotel+xml |
  
  Scenario Outline: capture hotel data
    Given the following hotels exist:
		|  name  |  city  |  room_count  |  rate  |
		| <name> | <city> | <room_count> | <rate> |
		And they are saved in the database
    When I request the hotel using <content_type>
		Then the response should be valid
		And the hotel name should be "<name>"
		And the response header "Content-type" should be "<content_type>"

		Examples:
			| name                 | city      |room_count | rate | content_type         |
			| Caelum Objects Hotel | Sao Paulo | 3         | 4    | application/xml      |
			| Restfulie Hotel      | Sao Paulo | 12        | 5    | vnd/caelum_hotel+xml |

