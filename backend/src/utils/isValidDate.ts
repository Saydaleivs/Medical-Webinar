const MAX_NOTIFICATION_DAY = 10;

export default function validateDate(dateString: string): boolean {
  const providedDate: Date = new Date(dateString);
  const currentDate: Date = new Date();

  // Check if the provided date is in the past
  // if (providedDate < currentDate) {
  //   return false;
  // }

  const differenceInMilliseconds: number = Math.abs(
    providedDate.getTime() - currentDate.getTime(),
  );
  const differenceInDays: number =
    differenceInMilliseconds / (1000 * 60 * 60 * 24);

  // Check if the difference is within the desired range (10 days)
  const isWithinRange: boolean = differenceInDays <= MAX_NOTIFICATION_DAY;

  return isWithinRange;
}
