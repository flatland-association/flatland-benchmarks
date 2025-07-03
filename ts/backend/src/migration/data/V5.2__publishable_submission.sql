-- Change the unpublished submission's user to the local dev user, so publishing
-- results can be manually tested:
-- http://localhost:4200/submissions/06ad18b5-e697-4684-aa7b-76b5c82c4307
UPDATE submissions
  SET submitted_by = '53e2038c-0c5f-4536-9a3c-71c82f49119a',
      submitted_by_username = 'User'
  WHERE id = '06ad18b5-e697-4684-aa7b-76b5c82c4307'
  