/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface BeforeUpdate {
    void handleBeforeUpdate(List<sObject> oldList, List<sObject> newList);
}