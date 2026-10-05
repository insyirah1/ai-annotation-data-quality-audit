-- =====================================
-- AI ANNOTATION DATA QUALITY AUDIT
-- =====================================

-- 1. Baseline record count
SELECT COUNT(*) AS total_annotations
FROM annotations;

-- 2. Duplicate task ID
SELECT task_id, COUNT(*) AS duplicate_count
FROM annotations
GROUP BY task_id
HAVING COUNT(*) > 1;

-- 3. Missing values
SELECT *
FROM annotations
WHERE task_id IS NULL OR task_id = ''
   OR annotator_id IS NULL OR annotator_id = ''
   OR task_type IS NULL OR task_type = ''
   OR label IS NULL OR label = ''
   OR reviewer_score IS NULL OR reviewer_score = ''
   OR status IS NULL OR status = ''
   OR submitted_date IS NULL OR submitted_date = '';
   
   -- 4. Orphan annotator ID
SELECT *
FROM annotations
LEFT JOIN annotators
ON annotations.annotator_id = annotators.annotator_id
WHERE annotations.annotator_id IS NOT NULL
  AND annotations.annotator_id <> ''
  AND annotators.annotator_id IS NULL;
  
 -- 5. Label consistency
SELECT task_id, label
FROM annotations
WHERE label IS NOT NULL
  AND label NOT IN ('Approved', 'Rejected', 'Needs Review');
  
 -- 6. Task type consistency
SELECT task_id, task_type
FROM annotations
WHERE task_type IS NOT NULL
  AND task_type NOT IN (
    'Data Annotation',
    'Response Evaluation',
    'Search Relevance',
    'Transcription'
  );
  
 -- 7. Status consistency
SELECT task_id, status
FROM annotations
WHERE status IS NOT NULL
  AND status NOT IN (
    'Completed',
    'Pending',
    'Reviewed'
  );
  
 -- 8. Reviewer score validation
SELECT task_id, reviewer_score
FROM annotations
WHERE reviewer_score IS NOT NULL
  AND reviewer_score NOT BETWEEN 1 AND 5;
  
 -- 9. Date validation
SELECT task_id, submitted_date
FROM annotations
WHERE submitted_date IS NOT NULL
  AND submitted_date <> ''
  AND date(submitted_date) IS NULL;
  
 -- =====================================
-- SQL RE-VALIDATION AFTER CLEANING
-- =====================================

-- 10. Label consistency re-validation
SELECT task_id, label
FROM annotations_cleaned
WHERE label IS NOT NULL
  AND label NOT IN ('Approved', 'Rejected', 'Needs Review');
  
 -- 11. Task type consistency re-validation
SELECT task_id, task_type
FROM annotations_cleaned
WHERE task_type IS NOT NULL
  AND task_type NOT IN (
    'Data Annotation',
    'Response Evaluation',
    'Search Relevance',
    'Transcription'
  );
  
 -- 12. Status consistency re-validation
SELECT task_id, status
FROM annotations_cleaned
WHERE status IS NOT NULL
  AND status NOT IN (
    'Completed',
    'Pending',
    'Reviewed'
  );
  
 -- 13. Reviewer score re-validation
SELECT task_id, reviewer_score
FROM annotations_cleaned
WHERE reviewer_score IS NOT NULL
  AND reviewer_score NOT BETWEEN 1 AND 5;
  
 -- 14. Date re-validation
SELECT task_id, submitted_date
FROM annotations_cleaned
WHERE submitted_date IS NOT NULL
  AND submitted_date <> ''
  AND date(submitted_date) IS NULL;
  
 -- 15. Missing values re-validation
SELECT *
FROM annotations_cleaned
WHERE task_id IS NULL OR task_id = ''
   OR annotator_id IS NULL OR annotator_id = ''
   OR task_type IS NULL OR task_type = ''
   OR label IS NULL OR label = ''
   OR reviewer_score IS NULL OR reviewer_score = ''
   OR status IS NULL OR status = ''
   OR submitted_date IS NULL OR submitted_date = '';
   
 -- 16. Orphan annotator ID re-validation
SELECT *
FROM annotations_cleaned
LEFT JOIN annotators
ON annotations_cleaned.annotator_id = annotators.annotator_id
WHERE annotations_cleaned.annotator_id IS NOT NULL
  AND annotations_cleaned.annotator_id <> ''
  AND annotators.annotator_id IS NULL;
  
-- 17. Duplicate task ID re-validation
SELECT task_id, COUNT(*) AS duplicate_count
FROM annotations_cleaned
GROUP BY task_id
HAVING COUNT(*) > 1;