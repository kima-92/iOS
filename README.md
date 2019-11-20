# iOS
iOS Engineers

## To-do

- [x] User can signup/register for an authenticated account as ~~either a `Organization` or~~ an `Employee` of a currently registered `Organization`. Each account must have the following properties at a minimum:
  * a unique `username` - String
	* a strong `password` - String
	* a unique and valid `email` - String
	* a valid `phoneNumber` - String or Int
	* a valid `streetAddress` - String
	* a valid `state` - String
	* a valid `zipcode` - String or Int
	* `organizationName` (for `Organizations`) or `fullName` (for `Employees`)
	* `contactPerson` - String
- [x] Authenticated `Organization` or `orgAdmin` or `employee` can view a list of available `snack`s. Each snack should have the following properties:
	* `name`
	* `type`
	* `numberOfServings`
	* `nutritionInfo` object with:
		- `calories` (per serving) - Double/Float
		- `totalFat` (per serving)- Double/Float
		- `totalSugars` (per serving) - Double/Float
		- `protein` (per serving) - Double/Float
		- `carbs` (per serving) - Double/Float
		- `allergens` - String
	 * `totalWeight` - Double/Float
	 * `price` - Double/Float
- [x] Authenticated `Employees`/organizations/orgadmins can make "one-time purchases" of `snack`s that can be delivered with the next upcoming `Organization` subscription order.
- [ ] organization can sign up/log in
- [ ] Authenticated `Employees` can request `snack` choices to request to be added to the next upcoming `Organization` subscription order.
- [ ] Authenticated `Organization` or `orgAdmin` can create, read, update and delete a list of `snack`s that they would like to have included in their order/subscription.
