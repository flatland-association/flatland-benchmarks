/**
 * Creates a Promise that will resolve after given delay.
 * @param delay time to wait in ms.
 */
export default function wait(delay = 0) {
  return new Promise<void>((resolve) => {
    setTimeout(() => {
      resolve()
    }, delay)
  })
}
