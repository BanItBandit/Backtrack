<?php
// Tag filter group. Expects: $tagsByCategory, $selTags (set by the page).
?>
<div class="filter-group">
    <h2 id="tags">Tags</h2>

    <?php foreach ($tagsByCategory as $cat => $catTags): ?>
        <?php $hasSelected = array_intersect(array_column($catTags, 'tag_id'), $selTags); ?>
        <details class="tag-category" <?= $hasSelected ? 'open' : '' ?>>
            <summary><?= htmlspecialchars($cat) ?></summary>
            <?php foreach ($catTags as $t): ?>
                <label>
                    <input type="checkbox" name="tag[]" value="<?= (int) $t['tag_id'] ?>"
                           <?= in_array((int) $t['tag_id'], $selTags, true) ? 'checked' : '' ?>>
                    <?= htmlspecialchars($t['tag_name']) ?>
                </label>
            <?php endforeach; ?>
        </details>
    <?php endforeach; ?>
</div>