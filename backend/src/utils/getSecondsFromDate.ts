export default function getSecondsFromDate(dateString: string) {
  const futureDate = new Date(dateString);
  const currentDate = new Date();

  // Check if the future date is in the future
  // if (futureDate < currentDate) {
  //   throw new Error('The date must be in the future');
  // }

  // Calculate the difference in milliseconds
  const differenceInMilliseconds = futureDate.getTime() - currentDate.getTime();

  // Convert milliseconds to seconds
  const seconds = Math.floor(differenceInMilliseconds / 1000);

  return seconds;
}
