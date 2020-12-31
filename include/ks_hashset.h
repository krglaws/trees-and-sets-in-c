#ifndef _KS_HASHSET_H_
#define _KS_HASHSET_H_


#include <ks_datacont.h>
#include <ks_list.h>
#include <ks_treeset.h>


/* -----------------------
 * notes: 
 *
 * ks_hashsets, unlike its inherited types ks_treeset and ks_treesetnode, are required to have the type defined
 * within the struct itself. This is to prevent two ks_dataconts of non-comparable types to be added into 
 * two separate buckets without error. ks_treesets and ks_treesetnodes on the other hand have their types
 * determined by the first ks_datacont that is passed into them.
 *
 * Since ks_hashsets are not iterable the way a ks_treeset is, ks_hashset_to_list() provides a means for iterating
 * over the contents of a ks_hashset.
 */
typedef struct ks_hashset ks_hashset;


struct ks_hashset
{
  enum ks_datatype type;

  unsigned int num_buckets;

  ks_treeset** buckets;
};


/* ----------------------------------
 * ks_hashset_new():
 * Creates a new empty ks_hashset.
 *
 * Inputs:
 * unsigned int buckets - the number of buckets that the new ks_hashset should contain.
 *
 * Returns:
 * ks_hashset* hs - a new empty ks_hashset.
 */
ks_hashset* ks_hashset_new(const enum ks_datatype type, const unsigned int num_buckets);


/* ---------------------------------
 * ks_hashset_delete():
 * Deletes a ks_hashset and all of its contents.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being deleted.
 *
 * Returns:
 * void
 */
void ks_hashset_delete(ks_hashset* hs);


/* --------------------------------
 * ks_hashset_add():
 * Adds a ks_datacont to a hashaset.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being added to.
 * ks_datacont* dc - the ks_datacont being added to 'hs'.
 *
 * Returns:
 * int result - (-1) if either param is NULL, or if the ks_datatype of 'dc' does not
 *              match the other ks_dataconts within the ks_hashset.
 *            - (0) 'dc' was successfully added to the ks_hashset. 
 *            - (1) 'dc' is already stored in the ks_hashset.
 *
 * Notes:
 * If 'dc' is successfully stored into the set, 'dc' should not be deleted by the user code,
 * as it will be directly stored into the tree. Otherwise a seg fault is likely to occur.
 * In the event that a value matching 'dc' is already present, or if 'hs' is NULL, 'dc' will
 * not be stored into the set, and 'dc' must be deleted by the user code.
 */
int ks_hashset_add(ks_hashset* hs, const ks_datacont* dc);


/* -------------------------
 * ks_hashset_remove():
 * Remove a ks_datacont from a ks_hashset.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being removed from.
 * ks_datacont* dc - the ks_datacont to be removed from 'hs'.
 *
 * Returns:
 * int result - (-1) if either param is NULL, or if 'dc' could not be found.
 *            - (0) on success.
 */
int ks_hashset_remove(ks_hashset* hs, const ks_datacont* dc);


/* ------------------------
 * ks_hashset_contains():
 * Searches for a specified ks_datacont value within a ks_hashset.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being searched.
 * ks_datacont* dc - the ks_datacont being searched for.
 *
 * Returns:
 * unsigned int result - (0) if 'dc' could not be found, or if either param is NULL.
 *                     - (1) 'hs' contains 'dc'.
 */
unsigned int ks_hashset_contains(const ks_hashset* hs, const ks_datacont* dc);


/* ------------------------
 * ks_hashset_count():
 * Counts the number of ks_dataconts contained within a ks_hashset.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being operated on.
 *
 * Returns:
 * unsigned int count - >= (0) the number of ks_dataconts within 'hs', (0) when 'hs' is NULL.
 */
unsigned int ks_hashset_count(const ks_hashset* hs);


/* ------------------------
 * ks_hashset_to_list():
 * Returns a ks_list of all ks_dataconts within a ks_hashset.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being operated on.
 *
 * Returns:
 * ks_list* ls - (NULL) if 'hs' is NULL.
 *          - a ks_list containing zero or more ks_dataconts.
 *
 * Notes:
 * The ks_dataconts contained within 'ls' are copies of those in 'hs', and can
 * be safely deleted by the user code without affecting the ks_dataconts within
 * 'hs'.
 */
ks_list* ks_hashset_to_list(const ks_hashset* hs);


/* --------------------
 * ks_hashset_optimize():
 * Balances all of the ks_treeset buckets in a ks_hashset to ensure O(log(N)) search
 * time.
 *
 * Inputs:
 * ks_hashset* hs - the ks_hashset being operated on.
 *
 * Returns:
 * void
 */
void ks_hashset_optimize(ks_hashset* hs);


#endif
